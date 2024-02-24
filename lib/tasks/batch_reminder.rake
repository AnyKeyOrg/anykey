# This task sends a batch of reminders for previously generated survey invitations
# Sends reminders to list of survey codes ingested from a CSV file via STDIN
# It will work on Heroku as well as in development
# Local usage: rake survey_invites:batch_reminder < /local/path/to/survey_codes.csv
# Remote usage: heroku run rake survey_invites:batch_reminder --no-tty < /local/path/to/survey_codes.csv

namespace :survey_invites do

  desc "Determines eligible participants and sends batch of survey invitations"

  task :batch_reminder, [:filename] => :environment do |task, args|

    require 'csv'

    # Silences output of SQL queries when run on Heroku
    Rails.logger.silence do
      
      # Ingest relevant data from batch csv file
      CSV.parse(STDIN.read, headers: true).each do |row|
      
        survey_code = row.to_hash.symbolize_keys[:survey_code]
        
        if survey_code.blank?
          puts "ERROR: survey_code cannot be blank"
        else
          survey_invite = SurveyInvite.find_by(survey_code: survey_code)
                    
          if survey_invite.blank?
            puts "ERROR: survey_code '#{survey_code}' does not exist"
          else
            puts "Found invitation with survey_code '#{survey_code}', generating reminder..."
            SurveyInviteMailer.send_reminder(survey_invite).deliver_now
            puts "Sent reminder to #{survey_invite.email}"
          end
        end
      end
      
    end
  end
end
