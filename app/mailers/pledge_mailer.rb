class PledgeMailer < ApplicationMailer
  
  default from: DO_NOT_REPLY

  def welcome_pledger(pledge)
    @pledge = pledge
    mail(to: pledge.email, subject: "Thank you for taking the GLHF pledge!")
  end
  
  def warn_pledger(warning)
    @warning = warning
    mail(to: warning.pledge.email, subject: "Warning about your conduct")
  end
  
  def revoke_pledger(revocation)
    @revocation = revocation
    mail(to: revocation.pledge.email, subject: "Your AnyKey badge has been revoked")
  end
  
  def notify_reporter_warning(warning)
    @warning = warning
    mail(to: warning.report.reporter_email, subject: "We've acted on your report")
  end
  
  def notify_reporter_revocation(revocation)
    @revocation = revocation
    mail(to: revocation.report.reporter_email, subject: "We've acted on your report")
  end
  
end
