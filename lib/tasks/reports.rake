# This task looks up twitch ID for all of
# the existing reports. This task should be
# ran once after staging implementation of twitch_id
# lookup at the time of report submittion.
# The search is thorough twitch API and
# is based on the twitch username
# that was reported. This task will ignore
# reports that have twitch_id already.

namespace :reports do

  desc "Looks up twtich ID for all existing reports"

  task :twitch_id_lookup => :environment do

    puts "Looking up twtich ID for existing reports..."

    Report.where(twitch_id: nil).each do |report|
      # Check if reported_twitch_name exists on Twitch
      response = HTTParty.get(URI.escape("#{ENV['TWITCH_API_BASE_URL']}/users?login=#{report.reported_twitch_name}"), headers: {"Client-ID": ENV['TWITCH_CLIENT_ID'], "Authorization": "Bearer #{TwitchToken.first.valid_token!}"})

      if response["data"].blank?
        report.update_attribute(:twitch_id, nil)
      else
        report.update_attribute(:twitch_id, response["data"][0]["id"])
      end
    end

  end

end
