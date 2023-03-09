class TwitchToken < ApplicationRecord
  validates_presence_of :access_token, :expires_in
  
  def valid_token!
    # If token is set to expire in less than a day, or if it is expired, request a new one
    if self.updated_at + self.expires_in < Time.now+1.day
      response = HTTParty.post(URI.escape("#{ENV['TWITCH_AUTH_BASE_URL']}/oauth2/token?client_id=#{ENV['TWITCH_CLIENT_ID']}&client_secret=#{ENV['TWITCH_CLIENT_SECRET']}&grant_type=client_credentials"))

      # Verify that a valid token has been received before setting it
      # Otherwise something has gone wrong so leave the token unchanged
      if response["access_token"].present?
        self.update(access_token: response["access_token"], expires_in: response["expires_in"])
      end
    end  
    
    self.access_token
  end

end
