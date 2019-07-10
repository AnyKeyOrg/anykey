class PledgesController < ApplicationController
  
  def index
    @pledge = Pledge.new
  end
  
  def create
    @pledge = Pledge.find_by(email: pledge_params[:email])
    
    if @pledge    
      # If no Twitch is linked, prompt for Twitch bage actication
      
      # If Twitch is linked
      flash.now[:alert] = "ima handle this"
      render(action: :index)
  
    else  
      @pledge = Pledge.new(pledge_params)
            
      if @pledge.save
        # Show thanks and prompt for Twitch badge activation
        flash[:notice] = "Successfully pledged"
        redirect_to root_path
      else
        flash.now[:alert] ||= ""
        @pledge.errors.full_messages.each do |message|
          flash.now[:alert] << message + ". "
        end
        render(action: :index)
      end
    end
  end
  
  private
    def pledge_params
      params.require(:pledge).permit(:first_name, :last_name, :email)
    end
  
end
