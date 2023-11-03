class CreateSurveyInvites < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_invites do |t|
      t.string :email
      t.string :survey_code
      t.string :surveyable_type
      t.string :survey_title
      t.string :survey_url
      t.datetime :sent_on

      t.timestamps
    end
  end
end
