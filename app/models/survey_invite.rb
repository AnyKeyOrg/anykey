class SurveyInvite < ApplicationRecord
  
  SURVEYABLE_TYPES = {
    verification:  "Verification",
    pledge:        "Pledge",
    report:        "Report",
    concern:       "Concern"
  }.freeze
  
  SURVEYABLE_SYSTEMS = {
    verification:  "Eligibility Certification System",
    pledge:        "GLHF Pledge",
    report:        "GLHF Pledge Report System",
    concern:       "Competitor Concern System"
  }.freeze
  
  validates_presence_of  :email,
                         :surveyable_type,
                         :survey_title,
                         :survey_url
  
  uniquify :survey_code, length: 6, chars: ('A'..'Z').to_a + ('0'..'9').to_a

  def url_with_code
    self.survey_url+'?code='+self.survey_code
  end

end
