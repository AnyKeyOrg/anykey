class RevocationsController < ApplicationController

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
      @revocation = Revocation.new
    else
      redirect_to staff_index_path
    end
  end
  
  def create
    if @reported_twitch_user == nil
      redirect_to staff_index_path
    elsif @pledge = Pledge.find_by(twitch_id: @reported_twitch_user)
      @revocation = Revocation.new(revocation_params)
      @revocation.report = @report
      @revocation.pledge = @pledge
      @revocation.reviewer = current_user
          
      if @revocation.save
        # Email revocation to pledger
        PledgeMailer.revoke_pledger(@revocation).deliver_now
        
        # Email reporter that action has been taken
        PledgeMailer.notify_reporter_revocation(@revocation).deliver_now
                
        # Revoke badge on Twitch (using allowlisted Helix v6 custom API endpoint)
        badge_result = HTTParty.delete(URI.escape("#{ENV['TWITCH_PLEDGE_BASE_URL']}?user_id=#{@pledge.twitch_id}&secret=#{ENV['TWITCH_PLEDGE_SECRET']}"), headers: {"Authorization": "Bearer #{TwitchToken.first.valid_token!}", "Client-ID": ENV['TWITCH_CLIENT_ID'], "Content-Type": "application/json"})

        @pledge.badge_revoked = true
        @pledge.revoked_on    = Time.now
        @pledge.save
        
        @report.revoked = true
        @report.reviewer = current_user
        @report.save
        
        flash[:notice] = "You revoked the badge from #{@report.reported_twitch_name} and sent them a notification at #{@pledge.email}."
        redirect_to reports_path
      else
        flash.now[:alert] ||= ""
        @revocation.errors.full_messages.each do |message|
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
      response = HTTParty.get(URI.escape("#{ENV['TWITCH_API_BASE_URL']}/users?login=#{@report.reported_twitch_name}"), headers: {"Client-ID": ENV['TWITCH_CLIENT_ID'], "Authorization": "Bearer #{TwitchToken.first.valid_token!}"})
      
      if response["data"].blank?
       @reported_twitch_user = nil
      else
        @reported_twitch_user = response["data"][0]["id"]
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
    
    def revocation_params
      params.require(:revocation).permit(:reason)
    end
  
end
