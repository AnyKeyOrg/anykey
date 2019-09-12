class WarningsController < ApplicationController
  
  layout "backstage"
  
  before_action :authenticate_user!
  before_action :ensure_staff
  before_action :find_report
  before_action :ensure_sane_review
  before_action :find_reported_twitch_user
  around_action :display_timezone
  
  def new
    if @reported_twitch_user == nil
      redirect_to staff_index_path
    elsif @pledge = Pledge.find_by(twitch_id: @reported_twitch_user)
      @warning = ConductWarning.new
    else
      redirect_to staff_index_path
    end
  end
  
  def create
    if @reported_twitch_user == nil
      redirect_to staff_index_path
    elsif @pledge = Pledge.find_by(twitch_id: @reported_twitch_user)
      @warning = ConductWarning.new(conduct_warning_params)
      @warning.report = @report
      @warning.pledge = @pledge
      @warning.reviewer = current_user
          
      if @warning.save
        # Email warning to pledger
        PledgeMailer.warn_pledger(@warning).deliver_now
        
        # TODO: email reporter that action has been taken
        
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
    
    def find_reported_twitch_user
      # Check if reported_twitch_name exists on Twitch
      response = HTTParty.get(URI.escape("#{ENV['TWITCH_API_BASE_URL']}/users?login=#{@report.reported_twitch_name}"), headers: {Accept: 'application/vnd.twitchtv.v5+json', "Client-ID": ENV['TWITCH_CLIENT_ID']})
      
      if response["users"].empty?
       @reported_twitch_user = nil
      else
        @reported_twitch_user = response["users"][0]["_id"]
      end
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
