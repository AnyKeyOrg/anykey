class ReportsController < ApplicationController

  layout "backstage",                       only: [ :index, :show ]

  before_action :authenticate_user!,        only: [ :index, :show, :dismiss, :undismiss ]
  before_action :ensure_staff,              only: [ :index, :show, :dismiss, :undismiss ]
  before_action :find_report,               only: [ :show, :dismiss, :undismiss ]
  around_action :display_timezone

  def index
    # f is used to filter reports by scope
    if params[:f].present? && Report::AVAILABLE_SCOPES.key?(params[:f].to_sym)
      @reports = eval("Report.includes(:pledge)."+params[:f]+".all.order(created_at: :desc)")
      # TODO add: paginate(page: params[:page], per_page: 30)
      @filter_category = params[:f]
    else
      @reports = Report.includes(:pledge).unresolved.all.order(created_at: :desc)
      @filter_category = "unresolved"
    end
  end

  def show
    # Create keybot advice message
    if !@report.twitch_id
      @message = "The reported Twitch user does not exist."
    elsif @pledge = Pledge.find_by(twitch_id: @report.twitch_id)
      @message = "The reported Twitch user signed the pledge as " + @pledge.twitch_display_name + " on " + @pledge.signed_on.strftime('%b. %-d, %Y.')
    else
      @message = "The reported Twitch user did not sign the pledge."
    end
    if @report.twitch_id
      @other_reports = Report.where(twitch_id: @report.twitch_id).where.not(id: @report.id)
    else
      @other_reports = nil
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
      set_twitch_id

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

  protected
    def find_report
      @report = Report.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to staff_index_path
    end

    def set_twitch_id
      # Check if reported_twitch_name exists on Twitch
      response = HTTParty.get(URI.escape("#{ENV['TWITCH_API_BASE_URL']}/users?login=#{@report.reported_twitch_name}"), headers: {"Client-ID": ENV['TWITCH_CLIENT_ID'], "Authorization": "Bearer #{TwitchToken.first.valid_token!}"})

      if response["data"].blank?
        @report.update_attribute(:twitch_id, nil)
      else
        @report.update_attribute(:twitch_id, response["data"][0]["id"])
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
