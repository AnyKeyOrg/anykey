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
