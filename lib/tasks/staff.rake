# This task sends a weekly stats update
# to staff via email. This task should
# be scheduled as a recurring job that
# happens Mondays at 9am UTC. Because we
# pull KPIs in PST/PDT, and our reporting
# week runs Monday-Sunday, this timing gives
# a 1-2 hour buffer.

namespace :staff do
  
  desc "Send weekly stats update email"

  task :send_weekly_stats_update => :environment do

    # Calculate end and start of reporting week
    e = Time.find_zone("Pacific Time (US & Canada)").now.beginning_of_day
    s = e-7.days

    # Send email
    StaffMailer.send_weekly_stats_update(s, e).deliver_now

  end

end