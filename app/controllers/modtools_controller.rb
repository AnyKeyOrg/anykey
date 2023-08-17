class ModtoolsController < ApplicationController
  
  require 'csv'

  layout "backstage"
      
  before_action :authenticate_user!
  before_action :ensure_staff
  
  
  # GET: Show mod view with Twitch ID lookup interface
  def badge_activation
    @badge_activation = BadgeActivation.new
  end
  
  # POST: Set AnyKey Twitch badge and keep log if successful
  def activate_badge
    unless params[:activate_badge_twitch_username].blank? || params[:activate_badge_twitch_id].blank?
      # Attempt to set badge on Twitch (using allowlisted Helix v6 custom API endpoint)
      url = "#{ENV['TWITCH_PLEDGE_BASE_URL']}"
      headers = {"Authorization": "Bearer #{TwitchToken.first.valid_token!}", "Client-ID": ENV['TWITCH_CLIENT_ID'], "Content-Type": "application/json"}
      body = {"user_id": "#{params[:activate_badge_twitch_id]}", "secret": "#{ENV['TWITCH_PLEDGE_SECRET']}"}.to_json
      
      badge_result = HTTParty.post(URI::Parser.new.escape(url), headers: headers, body: body)
      
      unless badge_result["error"].present?
        @badge_activation = BadgeActivation.new(twitch_username: params[:activate_badge_twitch_username], twitch_id: params[:activate_badge_twitch_id])
        @badge_activation.activator = current_user
        @badge_activation.activated_on = Time.now
        
        if @badge_activation.save
          flash[:notice] = "You activated the Twitch badge for #{@badge_activation.twitch_username}."
          redirect_to badge_activation_path
        else
          flash.now[:alert] ||= ""
          @badge_activation.errors.full_messages.each do |message|
            flash.now[:alert] << message + ". "
          end
          render(action: :badge_activation)
        end
      else
        flash.now[:alert] = "Badge could not be activated."
        render(action: :badge_activation)
      end
    else
      flash.now[:alert] = "Twitch username and ID are required."
      render(action: :badge_activation)
    end
  end
  
  # GET: Show mod view with one page miniapp
  def cert_validation
  end

  # POST: Crosscheck batch from CSV file and return results as JSON
  def validate_certs
    respond_to :json

    # Ensure request includes a CSV file
    if params[:validate_certs_input_csv].blank? || params[:validate_certs_input_csv].content_type != 'text/csv'
      render :json => {:error => 'The request must contain a CSV file', :code => '400'}, :status => 400
    
    # Ensure requests includes a Player ID type
    elsif params[:validate_certs_player_id_type].blank?
      render :json => {:error => 'The request must include a Player ID type', :code => '400'}, :status => 400
    
    # Check CSV file for crucial cert code column
    elsif !CSV.open(params[:validate_certs_input_csv].path, headers: true).read.headers.include? "certificate_code"
      render :json => {:error => 'The CSV file must include certificate_codes', :code => '400'}, :status => 400
    
    # Process CSV file
    else
      cross_check_results = []
      
      CSV.open(params[:validate_certs_input_csv].path, headers: true).each do |row|
        
        # Adds player_id_type from params to each player_data row hash
        player_data = {**row.to_hash.symbolize_keys, **{player_id_type: params[:validate_certs_player_id_type]}}

        unless player_data[:certificate_code].blank?
          verification = Verification.find_by(identifier: player_data[:certificate_code].upcase)
          certificate_code = {certificate_code: player_data[:certificate_code].upcase}

          # Check if cert code exists, look up state of request, and validate eligible player data with crosscheck
          # Note: uses ** double splat trick to easily merge hashes
          if verification.blank?
            authenticity = {authenticity: "not_found"}
            cross_check_results << {**certificate_code, **authenticity}
          elsif verification.withdrawn? || verification.denied? || verification.ignored? || verification.pending?
            authenticity = {authenticity: "invalid"}
            cross_check_results << {**certificate_code, **authenticity}
          elsif verification.eligible?
            authenticity = {authenticity: "valid"}
            validation_results = verification.validate(player_data)
            validation_results.each do |key, value|
              if value == "miss"
                authenticity = {authenticity: "inconsistent"}
              end
            end
            cross_check_results << {**certificate_code, **authenticity, **validation_results, **verification.validated_details}
          end
        end
      end
      
      # Ensure at least one actual cert code was included
      if cross_check_results.empty?
        render :json => {:error => 'The CSV file must include certificate_codes', :code => '400'}, :status => 400
      
      # Respond with JSON object of results
      else
        render :json => {results: cross_check_results}, :status => 200
      end
    end
    
  end
   
  private
    def ensure_staff
      unless current_user.is_moderator? || current_user.is_admin?
        redirect_to root_url
      end
    end
  
end
