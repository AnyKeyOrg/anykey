class ReportsController < ApplicationController
  
  layout "backstage",                       only: [ :index, :show ]
  
  skip_before_action :verify_authenticity_token, only: [ :watch, :unwatch ]
  
  before_action :authenticate_user!,        only: [ :index, :show, :dismiss, :undismiss, :watch, :unwatch ]
  before_action :ensure_staff,              only: [ :index, :show, :dismiss, :undismiss, :watch, :unwatch ]
  before_action :find_report,               only: [ :show, :dismiss, :undismiss, :watch, :unwatch ]
  before_action :find_reported_twitch_user, only: [ :show ]
  around_action :display_timezone
  
  def index
    # f is used to filter reports by scope
    # q is used to search for keywords
    # o is used to toggle ordering
    if params[:f].present? && Report::SORT_FILTERS.key?(params[:f].to_sym)
      @filter_category = params[:f]
    elsif params[:q].present?
      @filter_category = "all"
    else
      @filter_category = "unresolved"
    end
    
    if params[:o].present? && params[:o] == "asc"
      @ordering = "asc"
    else
      @ordering = "desc"
    end
    
    if params[:q].present?
      @pagy, @reports = eval("pagy(Report.#{@filter_category}.search('#{params[:q]}').order(created_at: :#{@ordering}))")
    else
      @pagy, @reports = eval("pagy(Report.#{@filter_category}.order(created_at: :#{@ordering}))")
    end
  end
  
  def show
    # Set Up Keybot Clues until we TODO: something better
    unless @reported_twitch_user == nil
      @pledge = Pledge.find_by(twitch_id: @reported_twitch_user)
    end
    
    # TODO: check if reporter has pledged (lookup email/Twitch name) and add info to keybot message
    # TODO: check if incident stream owner has pledged (Twitch name) and add info to keybot message
  end
  
  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)
  
    if @report.save
      # Email notification to staff
      StaffMailer.notify_staff_new_report(@report).deliver_now
      
      flash[:notice] = "You've successfully submitted the report. Thank you."
      redirect_to root_path
    else      
      flash.now[:alert] ||= ""
      @report.errors.full_messages.each do |message|
        flash.now[:alert] << message + ". "
      end      
      render(action: :new)
    end
  end

  def dismiss
    @report.dismissed = true
    @report.reviewer = current_user
    if @report.save
      flash[:notice] = "You dismissed the report about #{@report.reported_twitch_name}."
    end
    redirect_to reports_path
  end
  
  def undismiss
    @report.dismissed = false
    @report.reviewer = nil
    if @report.save
      flash[:notice] = "You undismissed the report about #{@report.reported_twitch_name}. It can now be reviewed again."
      redirect_to report_path(@report)
    else    
      redirect_to reports_path
    end
  end
  
  def watch
    respond_to do |format|
      if @report.update(watched: true)
        format.js
      end
    end
  end

  def unwatch
    respond_to do |format|
      if @report.update(watched: false)
        format.js
      end
    end
  end

  protected
    def find_report
      @report = Report.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to staff_index_path
    end
    
    # TODO: stop doing this! ;]
    # Fetch and store Twitch IDs when reports come in (as background task with Active Job / Resque)
    def find_reported_twitch_user
      # Check if reported_twitch_name exists on Twitch
      response = HTTParty.get(URI::Parser.new.escape("#{ENV['TWITCH_API_BASE_URL']}/users?login=#{@report.reported_twitch_name}"), headers: {"Client-ID": ENV['TWITCH_CLIENT_ID'], "Authorization": "Bearer #{TwitchToken.first.valid_token!}"})
      
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
    
    def display_timezone
      timezone = Time.find_zone( cookies[:browser_timezone] )
      Time.use_zone(timezone) { yield }
    end
    
    def report_params
      params.require(:report).permit(:reporter_email, :reporter_twitch_name, :reported_twitch_name, :incident_stream, :incident_occurred, :incident_description, :recommended_response, :image)
    end
  
end
