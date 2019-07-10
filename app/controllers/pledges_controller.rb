class PledgesController < ApplicationController
  
  def index
    @pledge = Pledge.new
  end
  
  def create
    @pledge = Pledge.new(pledge_params)
    
    # We shouldn't be using save to check this stuff in the controller,
    # we should probably just first check if the email exists and if it's
    # linked to a Twitch account
    
        
    if @pledge.save
      # Show thanks and prompt for Twitch badge activation
      flash[:notice] = "Successfully pledged"
      redirect_to root_path
    
    elsif @pledge.errors[:email].first == "has already been taken"
      # If no Twitch is linked, prompt for Twitch bage actication
      
      # If Twitch is linked
      flash.now[:alert] = "ima handle this"
      render(action: :index)
    
    else
      flash.now[:alert] ||= ""
      @pledge.errors.full_messages.each do |message|
        flash.now[:alert] << message + ". "
      end
      render(action: :index)
    end
    
    
    
    
  end
  
  private
    def pledge_params
      params.require(:pledge).permit(:first_name, :last_name, :email)
    end
  
end
