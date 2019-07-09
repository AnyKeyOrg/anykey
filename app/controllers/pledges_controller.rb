class PledgesController < ApplicationController
  
  def index
    @pledge = Pledge.new
  end
  
  def create
    @pledge = Pledge.new(pledge_params)
        
    if @pledge.save
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
  
  private
    def pledge_params
      params.require(:pledge).permit(:first_name, :last_name, :email, :twitch_username)
    end
  
  
end
