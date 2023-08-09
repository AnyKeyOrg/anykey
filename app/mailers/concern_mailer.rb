class ConcernMailer < ApplicationMailer
  
  default from: DO_NOT_REPLY
  
  def confirm_receipt(concern)
    @concern = concern
    mail(to: concern.concerned_email, subject: "We received your competitor concern. We'll review it soon!")
  end
  
  def review_finished(concern)
    @concern = concern
    mail(to: concern.concerned_email, subject: "We finished our review of your competitor concern")
  end
  
end
