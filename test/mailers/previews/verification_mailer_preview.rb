# Preview all emails at http://localhost:3000/rails/mailers/verification_mailer
class VerificationMailerPreview < ActionMailer::Preview
  def confirm_request
    VerificationMailer.confirm_request(Verification.first)
  end
  
  def confirm_request_voice
    VerificationMailer.confirm_request_voice(Verification.first)
  end
  
  def verify_request
    VerificationMailer.verify_request(Verification.first)
  end
  
  def deny_request
    VerificationMailer.deny_request(Verification.first)
  end
  
end
