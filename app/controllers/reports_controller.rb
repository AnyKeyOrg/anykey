class ReportsController < ApplicationController
  
  around_action :adjust_timezone,       only: [ :create ]
    
  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)
  
    if @report.save
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

  private
    def report_params
      params.require(:report).permit(:reporter_email, :reporter_twitch_name, :reported_twitch_name, :incident_stream, :incident_occurred, :timezone, :incident_description, :recommended_response, :image)
    end
    
    def adjust_timezone
      timezone = Time.find_zone( report_params[:timezone] )
      Time.use_zone(timezone) { yield }
    end  
  
end
