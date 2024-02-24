# This task sends a batch of survey invitations to all the eligible participants
# Determined using the criteria found in a JSON file ingested via STDIN
# It will work on Heroku as well as in development
# Local usage: rake survey_invites:batch_invitation < /local/path/to/survey_params.json
# Remote usage: heroku run rake survey_invites:batch_invitation --no-tty < /local/path/to/survey_params.json

# JSON file should include single hash with the following params:
# "surveyable_type": e.g. Verification, Pledge, Report, Concern
# "surveyable_criteria": e.g. where('created_at >= ? AND created_at < ?', Time.now.beginning_of_year, Time.now.end_of_year).order(created_at: :desc)
# "survey_title": e.g. 2020 Year End
# "survey_url": e.g. https://docs.google.com/forms/<IDENTIFIER>/viewform?usp=pp_url&entry.<ID>=<survey_code>
# Note: that everything but the survey_code we generate should be included in

namespace :survey_invites do

  desc "Determines eligible participants and sends batch of survey invitations"

  task :batch_invitation, [:filename] => :environment do |task, args|

    require 'json'
    require 'uri'
    
    # Silences output of SQL queries when run on Heroku
    Rails.logger.silence do
      puts "Determining eligible participants..."

      survey_params = JSON.parse(STDIN.read).symbolize_keys

      # Gentle checks ensures admin does not accidentally create nonsenical/destructive chain of commands
      if survey_params[:surveyable_type].blank?
        puts "ERROR: `surveyable_type` cannot be blank. Process halting."
      elsif !["Verification", "Pledge", "Report", "Concern"].map {|t| t == survey_params[:surveyable_type] }.include?(true)
        puts "ERROR: `surveyable_type` is not valid. Process halting."
      elsif survey_params[:surveyable_criteria].blank?
        puts "ERROR: `surveyable_criteria` cannot be blank. Process halting."
      elsif !survey_params[:surveyable_criteria].start_with?("where")
        puts "ERROR: `surveyable_criteria` must begin with `where`. Process halting."
      elsif survey_params[:survey_title].blank?
        puts "ERROR: `survey_title` cannot be blank. Process halting."
      elsif survey_params[:survey_url].blank?
        puts "ERROR: `survey_url` cannot be blank. Process halting."
      elsif !valid_url?(survey_params[:survey_url])
        puts "ERROR: `survey_url` must be a valid URL. Process halting."
      else
        participants = eval "#{survey_params[:surveyable_type]}.#{survey_params[:surveyable_criteria]}"

        emails = participants.pluck(:email).uniq
      
        puts "#{participants.count} #{survey_params[:surveyable_type].downcase.pluralize} matched the criteria"
      
        puts "#{emails.count} unique email addresses identified"

        puts emails
      
        puts "Sending batch of invitations..."
    
        emails.each do |email|
          survey_invite = SurveyInvite.new(email: email,
                                           surveyable_type: survey_params[:surveyable_type],
                                           survey_title: survey_params[:survey_title],
                                           survey_url: survey_params[:survey_url],
                                           sent_on: Time.now)
          if survey_invite.save        
            SurveyInviteMailer.send_invitation(survey_invite).deliver_now
            puts "Sent survey invite to #{survey_invite.email}"
          else
            puts "Something went wrong creating the invite for #{email}"
          end  
        end
      
        puts "Process complete."
      end
    end
  end

  def valid_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end
  
end