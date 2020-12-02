# Preview all emails at http://localhost:3000/rails/mailers/staff_mailer
class StaffMailerPreview < ActionMailer::Preview
  def notify_staff_new_report
    StaffMailer.notify_staff_new_report(Report.first)
  end
   
  def send_weekly_stats_update
    StaffMailer.send_weekly_stats_update(Time.now.beginning_of_day-7.days, Time.now.beginning_of_day)
  end 
end
