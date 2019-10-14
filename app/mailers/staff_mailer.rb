class StaffMailer < ApplicationMailer
  
  default from: DO_NOT_REPLY

  def notify_staff_new_report(report)
    @report = report
    @unresolved_count = Report.unresolved.count
    mail(to: "staff@anykey.org", subject: "New badge abuse report!")
  end
  
  def send_weekly_stats_update(start_of_week, end_of_week)
    @start_of_week = start_of_week
    @end_of_week = end_of_week
    @pledge_takers_count = Pledge.where('signed_on >= ? AND signed_on < ?', start_of_week, end_of_week).count
    @badge_activators_count = Pledge.where('twitch_authed_on >= ? AND twitch_authed_on < ?', start_of_week, end_of_week).count
    @pledge_referrers_count = Pledge.where('signed_on >= ? AND signed_on < ? AND referrer_id IS NOT NULL', start_of_week, end_of_week).group(:referrer_id).count.count
    @pledges_referred_count = Pledge.where('signed_on >= ? AND signed_on < ? AND referrer_id IS NOT NULL', start_of_week, end_of_week).count
    @report_filers_count = Report.where('created_at >= ? AND created_at < ?', start_of_week, end_of_week).group(:reporter_email).count.count
    @reports_filed_count = Report.where('created_at >= ? AND created_at < ?', start_of_week, end_of_week).count
    @reports_dismissed_count = Report.where('updated_at >= ? AND updated_at < ?', start_of_week, end_of_week).dismissed.count
    @warnings_issued_count = ConductWarning.where('created_at >= ? AND created_at < ?', start_of_week, end_of_week).count
    @badges_revoked_count = Revocation.where('created_at >= ? AND created_at < ?', start_of_week, end_of_week).count
    @affiliates_count = Affiliate.count
    
    mail(to: "staff@anykey.org", subject: "AnyKey stats update for #{l(start_of_week, format: '%b. %-d')} - #{l(end_of_week-1.minutes, format: '%b. %-d, %Y')}")
  end
  
end
