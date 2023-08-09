# Preview all emails at http://localhost:3000/rails/mailers/concern_mailer
class ConcernMailerPreview < ActionMailer::Preview
  
  def confirm_receipt
    ConcernMailer.confirm_receipt(Concern.last)
  end
  
  def review_finished
    ConcernMailer.review_finished(Concern.all.reviewed.last)
  end

end
