# This task refreshes the Twitch IDs on reports
# The task is non-destructive, and only searches for Twitch IDs not yet set
# It is designed to be run once after Twitch ID storage is deployed in Aug. 2023
# Twitch API rate limit is 800/minute
# In dev it seemed the rate limit buket never depleted
# With ~5000 reports, and up to 3 IDs/report
# The task could take ~20 minutes to run

namespace :reports do
  
  desc "Looks up Twitch IDs for usernames submitted in reports"

  task :refresh_twitch_ids => :environment do
    puts "Beginning Twitch ID refresh for reports..."
    Report.all.each do |report|
      puts "Updating Report #{report.id}"
      if report.reporter_twitch_name && report.reporter_twitch_id.blank?
        report.update(reporter_twitch_id: lookup_twitch_id(report.reporter_twitch_name))
      end
      if report.reported_twitch_name && report.reported_twitch_id.blank?
        report.update(reported_twitch_id: lookup_twitch_id(report.reported_twitch_name))
      end
      if report.incident_stream && report.incident_stream_twitch_id.blank?
        report.update(incident_stream_twitch_id: lookup_twitch_id(report.incident_stream))
      end
    end
    puts "Twitch ID refresh for reports complete"
  end
  
  def lookup_twitch_id(twitch_username)
    # Only lookup IDs for valid Twitch usernames (4-25 alphanumeric incl. underscore)
    if twitch_username.match? /^([A-Za-z0-9_]{4,25})$/
      url      = "#{ENV['TWITCH_API_BASE_URL']}/users?login=#{twitch_username}"
      headers  = {"Client-ID": ENV['TWITCH_CLIENT_ID'], "Authorization": "Bearer #{TwitchToken.first.valid_token!}"}
      response = HTTParty.get(URI::Parser.new.escape(url), headers: headers)
      puts "Looking up Twitch user #{twitch_username}"
      puts "Twitch rate limit remaining: #{response.headers['ratelimit-remaining']}"
      if !response["data"].blank?
        return response["data"][0]["id"]
      end
    end
    return nil
  end
  
end