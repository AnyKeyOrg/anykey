class SurveyInviteMailer < ApplicationMailer
  
  default from: DO_NOT_REPLY
  
  def send_invitation(survey_invite)
    @survey_invite = survey_invite
    mail(to: survey_invite.email, subject: "Invitation to participate in the #{SurveyInvite::SURVEYABLE_SYSTEMS[@survey_invite.surveyable_type.downcase.to_sym]} #{survey_invite.survey_title}")
  end
  
end
