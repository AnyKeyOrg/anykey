class PledgesController < ApplicationController
  
  layout "backstage", only: [ :index ]
  
  before_action :authenticate_user!, only: [ :index ]
  before_action :ensure_staff, only: [ :index ]
  before_action :find_pledge, only: [ :show ]
  before_action :handle_twitch_auth, only: [ :new ]
  
  def index
    # per_page is a silent param to show more records per page
    if params[:per_page].present?
      per_page = params[:per_page]
    else
      per_page = 30
    end

    # f is used to filter reports by scope
    # q is used to search for keywords
    # o is used to toggle ordering
    if params[:f].present? && Pledge::SORT_FILTERS.key?(params[:f].to_sym)
      @filter_category = params[:f]
    else
      @filter_category = "all"
    end
    
    if params[:o].present? && params[:o] == "asc"
      @ordering = "asc"
    else
      @ordering = "desc"
    end
    
    if params[:q].present?
      @pledges = eval("Pledge.#{@filter_category}.search('#{params[:q]}').order(signed_on: :#{@ordering}).paginate(page: params[:page], per_page: #{per_page.to_s})")
    else
      @pledges = eval("Pledge.#{@filter_category}.order(signed_on: :#{@ordering}).paginate(page: params[:page], per_page: #{per_page.to_s})")
    end
  end
  
  def new
    @pledge = Pledge.new
    @pledges_count = Pledge.cached_count
    @leaders = Pledge.cached_leaders
  end
  
  def create
    @pledge = Pledge.find_by(email: pledge_params[:email])
    
    if @pledge
      
      # Set cookie to enforce single visit to redirect page
      cookies[:pledge_redirect] =  { value: true, expires: 5.minutes }
      
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
        if @referrer
          @referrer.increment!(:referrals_count)
        end
        
        # TODO: email referrer

        # Set cookie to enforce single visit to redirect page
        cookies[:pledge_redirect] =  { value: true, expires: 5.minutes }
        
        redirect_to pledge_path(@pledge)
      else
        flash.now[:alert] ||= ""
        @pledge.errors.full_messages.each do |message|
          flash.now[:alert] << message + ". "
        end
        @pledges_count = Pledge.cached_count
        @leaders = Pledge.cached_leaders
        render(action: :new)
      end
    end
  end
  
  def show
    # Reroute to staff view when applicable
    if staff_view?
      authenticate_user!
      ensure_staff

      render action: "staff_show", layout: "backstage"    
    
    # Otherwise, check for cookie to ensure user visit is valid
    elsif cookies[:pledge_redirect].blank?
      redirect_to root_url
    
    else
      @pledges_count = Pledge.cached_count
      cookies.delete(:pledge_redirect)
    end
  end
  
  def referral_lookup
    @pledge = Pledge.new
  end
  
  def referral_send
    @pledge = Pledge.find_by(email: pledge_params[:email])

    if @pledge
      # Email pledger
      PledgeMailer.send_pledger_referral(@pledge).deliver_now
      
      flash[:notice] = "We've successfully sent an email with your referral link. Check your inbox!"
      redirect_to root_path
    else
      flash.now[:alert] ||= "Email address not found."
      render(action: :referral_lookup)
    end
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
        response = HTTParty.post(URI::Parser.new.escape("#{ENV['TWITCH_AUTH_BASE_URL']}/oauth2/token?client_id=#{ENV['TWITCH_CLIENT_ID']}&client_secret=#{ENV['TWITCH_CLIENT_SECRET']}&code=#{params[:code]}&grant_type=authorization_code&redirect_uri=#{ENV['TWITCH_REDIRECT_URL']}"))

        # Use token to view Twitch credentials and store for validation
        if response["access_token"].present?
          twitch_user = HTTParty.get(URI::Parser.new.escape("#{ENV['TWITCH_API_BASE_URL']}/users"), headers: {"Authorization": "Bearer #{response['access_token']}", "Client-ID": ENV['TWITCH_CLIENT_ID']})
                          
          if !twitch_user["data"].blank?
            if Pledge.find_by(twitch_id: twitch_user["data"][0]["id"])
              
              # Set cookie to enforce single visit to redirect page
              cookies[:pledge_redirect] =  { value: true, expires: 5.minutes }

              # Reroute if Twitch user already pledged
              redirect_to pledge_path(@pledge, params: {status: 'duplicate'})
            
            else              
              # Set badge on Twitch (using allowlisted Helix v6 custom API endpoint)
              badge_result = HTTParty.post(URI::Parser.new.escape("#{ENV['TWITCH_PLEDGE_BASE_URL']}"), headers: {"Authorization": "Bearer #{TwitchToken.first.valid_token!}", "Client-ID": ENV['TWITCH_CLIENT_ID'], "Content-Type": "application/json"}, body: {"user_id": "#{twitch_user["data"][0]["id"]}", "secret": "#{ENV['TWITCH_PLEDGE_SECRET']}"}.to_json)

              if badge_result["error"].present?
                # Set cookie to enforce single visit to redirect page
                cookies[:pledge_redirect] =  { value: true, expires: 5.minutes }
                
                #TODO: create an error message
                redirect_to pledge_path(@pledge, params: {status: 'returning'})
              
              else
                @pledge.twitch_id           = twitch_user["data"][0]["id"]
                @pledge.twitch_display_name = twitch_user["data"][0]["display_name"]
                @pledge.twitch_email        = twitch_user["data"][0]["email"]
                @pledge.twitch_authed_on    = Time.now
                
                if @pledge.save
                
                  # Set cookie to enforce single visit to redirect page
                  cookies[:pledge_redirect] =  { value: true, expires: 5.minutes }

                  redirect_to pledge_path(@pledge)
                
                else
                  #TODO: catch failure and send to an error page
                end
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
    
    def staff_view?
      params[:staff].present?
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
