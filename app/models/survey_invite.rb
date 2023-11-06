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


  # Google Form pre-fille links look like:
  # https://docs.google.com/forms/IDENTIFIER/viewform?usp=pp_url&entry.IDNUMBER=DATA
  # Admins should provide the full link apart from DATA as the survey_url
  def url_with_code
    self.survey_url+self.survey_code
  end

end
