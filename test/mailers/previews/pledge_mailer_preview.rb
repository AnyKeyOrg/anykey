# Preview all emails at http://localhost:3000/rails/mailers/pledge_mailer
class PledgeMailerPreview < ActionMailer::Preview
  def welcome_pledger
    PledgeMailer.welcome_pledger(Pledge.last)
  end
    
  def send_pledger_referral
    PledgeMailer.send_pledger_referral(Pledge.last)
  end
  
  def confirm_receipt
    PledgeMailer.confirm_receipt(Report.last)
  end
    
  def warn_pledger
    PledgeMailer.warn_pledger(ConductWarning.last)
  end
    
  def revoke_pledger
    PledgeMailer.revoke_pledger(Revocation.last)
  end
    
  def notify_reporter_warning
    PledgeMailer.notify_reporter_warning(ConductWarning.last)
  end
    
  def notify_reporter_revocation
    PledgeMailer.notify_reporter_revocation(Revocation.last)
  end
end
