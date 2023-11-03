# Preview all emails at http://localhost:3000/rails/mailers/survey_invite_mailer
class SurveyInviteMailerPreview < ActionMailer::Preview
  def send_invitation
    SurveyInviteMailer.send_invitation(SurveyInvite.last)
  end
end
