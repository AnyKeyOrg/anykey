# This task retrieves the Twitch API v6 app access token for the first time
# And sets the single record of the TwitchToken model accordingly
# Run this task before rolling over to the new Twitch v6 API (helix)
# Prior to the shutfown of v5 (kraken) on February 28, 2022

namespace :twitch_token do
  
  desc "Creates Twitch API app access token"

  task :request => :environment do

    puts "Requesting app access token from Twitch..."
    
    # If no records are yet present in the DB, create an empty one
    # Otherweise if this rake task is being run on a DB after the rollover already took place
    # This code will just refresh the existing token
    twitch_token = TwitchToken.first_or_create()
    
    # Attempt to get app access token from Twitch
    response = HTTParty.post(URI.escape("#{ENV['TWITCH_AUTH_BASE_URL']}/oauth2/token?client_id=#{ENV['TWITCH_CLIENT_ID']}&client_secret=#{ENV['TWITCH_CLIENT_SECRET']}&grant_type=client_credentials"))
        
    # Set access token if successfully retrieved
    if response["access_token"].present?
      twitch_token.access_token = response["access_token"]
      twitch_token.expires_in = response["expires_in"]
      puts "Token received and set."
      
    # Otherwise something has gone wrong, so set effectively null values for the token  
    else
      twitch_token.access_token = none
      twitch_token.expires_in = 0
      puts "Token not received, null token set."    
    end
    
    twitch_token.save
  end

end