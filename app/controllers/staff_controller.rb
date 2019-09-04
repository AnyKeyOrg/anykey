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
      @message = "The reported Twitch user does not exist."
      @actionable = false
    elsif pledge = Pledge.find_by(twitch_id: reported_twitch_user["users"][0]["_id"])
      @message = "The reported Twitch user signed the pledge as " + pledge.twitch_display_name + " on " + pledge.signed_on.strftime('%b. %-d, %Y.')
      @actionable = true
    else
      @message = "The reported Twitch user did not sign the pledge."
      @actionable = false
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
