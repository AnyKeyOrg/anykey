class StaffController < ApplicationController
      
  before_action :authenticate_user!
  before_action :ensure_staff
  before_action :find_report, only: [ :report_review ]
  around_action :display_timezone
  
  
  def index
    @user = current_user
  end
  
  def reports
    # f is used to filter reports by scope
    if params[:f].present? && Report::AVAILABLE_SCOPES.key?(params[:f].to_sym)
      @reports = eval("Report."+params[:f]+".all.order(created_at: :desc)")
      #paginate(page: params[:page], per_page: 30)
      @filter_category = params[:f]
    else
      @reports = Report.all.order(created_at: :desc)
      @filter_category = "all"
    end
    
    
    
  end
  
  def report_review
    # Check if reported_twitch_name exists on Twitch
    # And if so, look up Twitch ID and check if they have pledged
    reported_twitch_user = HTTParty.get(URI.escape("#{ENV['TWITCH_API_BASE_URL']}/users?login=#{@report.reported_twitch_name}"), headers: {Accept: 'application/vnd.twitchtv.v5+json', "Client-ID": ENV['TWITCH_CLIENT_ID']})
    
    if reported_twitch_user["users"].empty?
      # That twitch user doesn't exist
      Rails.logger.info("# That twitch user doesn't exist")    
    elsif pledge = Pledge.find_by(twitch_id: reported_twitch_user["users"][0]["_id"])
      # That twitch user signed our pledge as pledge.twitch_username    
      Rails.logger.info("# That twitch user signed our pledge as: " + pledge.twitch_display_name)    
    else
      # That twitch user didn't sign our pledge
      Rails.logger.info("# That twitch user didn't sign our pledge")
    end    
  end
  
  protected
    def find_report
      @report = Report.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to staff_index_path
    end
    
  private
    def ensure_staff
      unless current_user.is_moderator? || current_user.is_admin?
        redirect_to root_url
      end
    end
    
    def display_timezone
      timezone = Time.find_zone( cookies[:browser_timezone] )
      Time.use_zone(timezone) { yield }
    end
  
end
