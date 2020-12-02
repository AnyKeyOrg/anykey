# Preview all emails at http://localhost:3000/rails/mailers/pledge_mailer
class PledgeMailerPreview < ActionMailer::Preview
  def welcome_pledger
    PledgeMailer.welcome_pledger(Pledge.first)
  end
    
  def send_pledger_referral
    PledgeMailer.send_pledger_referral(Pledge.first)
  end
    
  def warn_pledger
    PledgeMailer.warn_pledger(ConductWarning.first)
  end
    
  def revoke_pledger
    PledgeMailer.revoke_pledger(Revocation.first)
  end
    
  def notify_reporter_warning
    PledgeMailer.notify_reporter_warning(ConductWarning.first)
  end
    
  def notify_reporter_revocation
    PledgeMailer.notify_reporter_revocation(Revocation.first)
  end
end
