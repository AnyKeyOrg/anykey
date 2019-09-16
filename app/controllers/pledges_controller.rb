class PledgesController < ApplicationController
  
  layout "backstage", only: [ :index ]
  
  before_action :authenticate_user!, only: [ :index ]
  before_action :ensure_staff, only: [ :index ]
  before_action :find_pledge, only: [ :show ]
  before_action :handle_twitch_auth, only: [ :new ]
  
  def index
    @pledges = Pledge.all.order(signed_on: :desc).paginate(page: params[:page], per_page: 30)
  end
  
  def new
    @pledge = Pledge.new
    @pledges_count = Pledge.count
  end
  
  
  def create
    @pledge = Pledge.find_by(email: pledge_params[:email])
    
    if @pledge    
      redirect_to pledge_path(@pledge, params: {status: 'returning'})
      
    else  
      @pledge = Pledge.new(pledge_params)
      
      unless params[:ref].blank?
        if @referrer = Pledge.find_by(identifier: params[:ref]) 
          @pledge.referrer = @referrer
        end
      end
            
      if @pledge.save
        # Email pledger
        PledgeMailer.welcome_pledger(@pledge).deliver_now

        # Increment referral counter
        @referrer.increment!(:referrals_count)

        # TODO: email referrer

        redirect_to pledge_path(@pledge)
      else
        flash.now[:alert] ||= ""
        @pledge.errors.full_messages.each do |message|
          flash.now[:alert] << message + ". "
        end
        @pledges_count = Pledge.count
        render(action: :new)
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
      
      # If a user arrives at the pledge with a code and a state set
      # We expect they are returning from a Twitch auth flow
      # But we perform checks to ensure all is well before proceeeding
      
      if params[:code].present? && params[:state].present?
        @pledge = Pledge.find_by(identifier: params[:state])
        
        # Ensure pledge exists
        unless @pledge
          redirect_to root_url
        end
        
        # Ensure Twitch account has not yet been linked to pledge
        unless @pledge.twitch_id.blank?
          redirect_to root_url
        end
        
        # Request an access token from Twitch
        response = HTTParty.post(URI.escape("#{ENV['TWITCH_API_BASE_URL']}/oauth2/token?client_id=#{ENV['TWITCH_CLIENT_ID']}&client_secret=#{ENV['TWITCH_CLIENT_SECRET']}&code=#{params[:code]}&grant_type=authorization_code&redirect_uri=#{ENV['TWITCH_REDIRECT_URL']}"))

        # Use token to view Twitch credentials and store for validation
        if response["access_token"].present?
          twitch_user = HTTParty.get(URI.escape("#{ENV['TWITCH_API_BASE_URL']}/user"), headers: {Accept: 'application/vnd.twitchtv.v5+json', Authorization: "OAuth #{response['access_token']}", "Client-ID": ENV['TWITCH_CLIENT_ID']})
                    
          if twitch_user.present?
            if Pledge.find_by(twitch_id: twitch_user["_id"])
              # Reroute if Twitch user already pledged
              redirect_to pledge_path(@pledge, params: {status: 'duplicate'})
            
            else
              @pledge.twitch_id           = twitch_user["_id"]
              @pledge.twitch_display_name = twitch_user["display_name"]
              @pledge.twitch_email        = twitch_user["email"]
              @pledge.twitch_authed_on    = Time.now
              
              # Set badge on Twitch
              badge_result = HTTParty.put(URI.escape("#{ENV['TWITCH_API_BASE_URL']}/users/#{@pledge.twitch_id}/chat/badges/pledge?secret=#{ENV['TWITCH_PLEDGE_SECRET']}"), headers: {Accept: 'application/vnd.twitchtv.v5+json', "Client-ID": ENV['TWITCH_CLIENT_ID']})
              
              if @pledge.save
                redirect_to pledge_path(@pledge)
              else
                #TODO: catch failure and send to an error page
              end
            end
          else
            #TODO: catch failure and send to an error page
          end
        else
          #TODO: catch failure and send to an error page
        end
      end
    end

  private
    def ensure_staff
      unless current_user.is_moderator? || current_user.is_admin?
        redirect_to root_url
      end
    end
      
    def pledge_params
      params.require(:pledge).permit(:first_name, :last_name, :email)
    end
  
end
