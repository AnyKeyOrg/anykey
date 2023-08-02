class ConcernsController < ApplicationController
  
  around_action :display_timezone
  
  def new
    @concern = Concern.new
  end

  def create
    @concern = Concern.new(concern_params)

    if @concern.save
      # TODO: send notification to staff
      
      # Email confirmation to concerned player
      # ConcernMailer.confirm_receipt(@concern).deliver_now
      
      flash[:notice] = "You've successfully submitted your concern. Thank you."
      redirect_to root_path
    else
      flash.now[:alert] ||= ""
      @concern.errors.full_messages.each do |message|
        flash.now[:alert] << message + ". "
      end
      render(action: :new)
    end
  end
  
  private
    def display_timezone
      timezone = Time.find_zone( cookies[:browser_timezone] )
      Time.use_zone(timezone) { yield }
    end
    
    def concern_params
      params.require(:concern).permit(:concerning_player_id, :concerning_player_id_type, :background, :description, :recommended_response, :concerned_email, :concerned_cert_code, screenshots: [])
    end
    
end
