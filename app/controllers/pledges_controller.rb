class PledgesController < ApplicationController
  
  before_action :find_pledge, only: [ :show ]
  
  
  def index
    @pledge = Pledge.new
  end
  
  def create
    @pledge = Pledge.find_by(email: pledge_params[:email])
    
    if @pledge    
      redirect_to pledge_url(@pledge, params: {status: 'returning'})
      
    else  
      @pledge = Pledge.new(pledge_params)
            
      if @pledge.save
        redirect_to pledge_url(@pledge)
      else
        flash.now[:alert] ||= ""
        @pledge.errors.full_messages.each do |message|
          flash.now[:alert] << message + ". "
        end
        render(action: :index)
      end
    end
  end
  
  def show
  end
  
  protected
    def find_pledge
      @pledge = Pledge.find_by(identifier: params[:id])
      unless @pledge
        redirect_to root_url
      end
    end

  private
    def pledge_params
      params.require(:pledge).permit(:first_name, :last_name, :email)
    end
  
end
