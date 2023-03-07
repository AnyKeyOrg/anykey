class VerificationMailer < ApplicationMailer
  
  default from: DO_NOT_REPLY

  def confirm_request(verification)
    @verification = verification
    mail(to: verification.email, subject: "We received your eligibility verification request. We'll review it soon!")
  end
  
  def confirm_request_voice(verification)
    @verification = verification
    mail(to: verification.email, subject: "We received your eligibility verification request. Here's your next step!")
  end
  
  def verify_request(verification)
    @verification = verification
    mail(to: verification.email, subject: "")
  end
  
  def deny_request(verification)
    @verification = verification
    mail(to: verification.email, subject: "")
  end
  
end
