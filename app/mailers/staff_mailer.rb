class StaffMailer < ApplicationMailer
  
  default from: DO_NOT_REPLY

  def notify_staff_new_report(report)
    @report = report
    @unresolved_count = Report.unresolved.count
    mail(to: "staff@anykey.org", subject: "New badge abuse report!")
  end
  
end
