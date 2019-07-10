class PledgesController < ApplicationController
  
  before_action :find_pledge, only: [ :show ]
  before_action :handle_twitch_auth, only: [ :show ]
  
  
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
    
    def handle_twitch_auth
      if params[:code].present?
        # POST https://id.twitch.tv/oauth2/token
        #     ?client_id=<your client ID>
        #     &client_secret=<your client secret>
        #     &code=<authorization code received above>
        #     &grant_type=authorization_code
        #     &redirect_uri=<your registered redirect URI>
    
    end

  private
    def pledge_params
      params.require(:pledge).permit(:first_name, :last_name, :email)
    end
  
end
