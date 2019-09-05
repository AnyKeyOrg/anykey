class StaffController < ApplicationController
      
  before_action :authenticate_user!
  before_action :ensure_staff
  before_action :find_report,                 only: [ :report_review, :report_dismiss, :report_undismiss, :new_warning, :create_warning ]
  before_action :find_reported_twitch_user,   only: [ :report_review, :new_warning, :create_warning ]
  around_action :display_timezone
  
  
  def index
  end
  
  def reports
    # f is used to filter reports by scope
    if params[:f].present? && Report::AVAILABLE_SCOPES.key?(params[:f].to_sym)
      @reports = eval("Report."+params[:f]+".all.order(created_at: :desc)")
      #paginate(page: params[:page], per_page: 30)
      @filter_category = params[:f]
    else
      @reports = Report.unresolved.all.order(created_at: :desc)
      @filter_category = "unresolved"
    end
  end
  
  def report_review
    # Create keybot advice message
    if @reported_twitch_user == nil
      @message = "The reported Twitch user does not exist."
    elsif @pledge = Pledge.find_by(twitch_id: @reported_twitch_user)
      @message = "The reported Twitch user signed the pledge as " + @pledge.twitch_display_name + " on " + @pledge.signed_on.strftime('%b. %-d, %Y.')
    else
      @message = "The reported Twitch user did not sign the pledge."
    end
    
    # TODO: check is reporter has pledged (lookup email/Twitch name)
  end
  
  def report_dismiss
    @report.dismissed = true
    @report.reviewer = current_user
    if @report.save
      flash[:notice] = "You dismissed the report about #{@report.reported_twitch_name}."
    end
    redirect_to staff_reports_path
  end
  
  def report_undismiss
    @report.dismissed = false
    @report.reviewer = nil
    if @report.save
      flash[:notice] = "You undismissed the report about #{@report.reported_twitch_name}. It can now be reviewed again."
      redirect_to staff_report_review_path(@report)
    else    
      redirect_to staff_reports_path
    end
  end
  
  def new_warning
    if @reported_twitch_user == nil
      redirect_to staff_index_path
    elsif @pledge = Pledge.find_by(twitch_id: @reported_twitch_user)
      @warning = ConductWarning.new
    else
      redirect_to staff_index_path
    end
  end
  
  def create_warning
    if @reported_twitch_user == nil
      redirect_to staff_index_path
    elsif @pledge = Pledge.find_by(twitch_id: @reported_twitch_user)
      @warning = ConductWarning.new(conduct_warning_params)
      @warning.report = @report
      @warning.pledge = @pledge
      @warning.reviewer = current_user
          
      if @warning.save
        # TODO: send email to reported pledger here
        @report.warned = true
        @report.reviewer = current_user
        @report.save        
        
        flash[:notice] = "You sent a warning to #{@pledge.email} (#{@report.reported_twitch_name})."
        
        redirect_to staff_reports_path
      else
        flash.now[:alert] ||= ""
        @warning.errors.full_messages.each do |message|
          flash.now[:alert] << message + ". "
        end
        render(action: :new_warning)
      end
    else
      redirect_to staff_index_path
    end
  end
  
  protected
    def find_report
      @report = Report.find(params[:id])
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
    
    def display_timezone
      timezone = Time.find_zone( cookies[:browser_timezone] )
      Time.use_zone(timezone) { yield }
    end
    
    def conduct_warning_params
      params.require(:conduct_warning).permit(:reason)
    end
  
end
