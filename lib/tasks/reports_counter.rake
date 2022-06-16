# This task resets the reports_count of existing pledges by reflecting
# the existing reports in the database. This task should be run
# after the rake task "reports:twitch_id_lookup" is run,
# because it looks up using twitch_id as a key

namespace :pledges do

  desc "Reset the reports_count for existing pledges"

  task :reset_reports_count => :environment do

    puts "Resetting reports_coun for existing pledges..."

    Pledge.all.each do |pledge|
      Pledge.reset_counters(pledge.id, :reports)
    end
  end
end
