class WarningsController < ApplicationController
  
  layout "backstage"
  
  before_action :authenticate_user!
  before_action :ensure_staff
  before_action :find_report
  before_action :ensure_sane_review
  around_action :display_timezone
  
  def new
    if @pledge = @report.reported_pledge
      @warning = ConductWarning.new
    else
      redirect_to staff_index_path
    end
  end
  
  def create
    if @pledge = @report.reported_pledge
      @warning = ConductWarning.new(conduct_warning_params)
      @warning.report = @report
      @warning.pledge = @pledge
      @warning.reviewer = current_user
          
      if @warning.save
        # Email warning to pledger
        PledgeMailer.warn_pledger(@warning).deliver_now
        
        # Email reporter that action has been taken
        PledgeMailer.notify_reporter_warning(@warning).deliver_now
        
        @report.warned = true
        @report.reviewer = current_user
        @report.save
        
        flash[:notice] = "You sent a warning to #{@pledge.email} (#{@report.reported_twitch_name})."
        redirect_to reports_path
      else
        flash.now[:alert] ||= ""
        @warning.errors.full_messages.each do |message|
          flash.now[:alert] << message + ". "
        end
        render(action: :new)
      end
    else
      redirect_to staff_index_path
    end 
  end

  protected
    def find_report
      @report = Report.find(params[:report_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to staff_index_path
    end

  private
    def ensure_staff
      unless current_user.is_moderator? || current_user.is_admin?
        redirect_to root_url
      end
    end
    
    def ensure_sane_review
      unless !@report.dismissed && !@report.warned && !@report.revoked
        redirect_to staff_index_path
      end
    end
    
    def display_timezone
      timezone = Time.find_zone( cookies[:browser_timezone] )
      Time.use_zone(timezone) { yield }
    end
  
    def conduct_warning_params
      params.require(:conduct_warning).permit(:reason)
    end
  
end
