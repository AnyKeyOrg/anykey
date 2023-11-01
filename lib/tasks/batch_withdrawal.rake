# This task queitly withdraws a batch of certificates from a CSV file using STDIN
# It will work on Heroku as well as in development
# Local usage: rake verifications:batch_withdrawal < /local/path/to/cert_batch.csv
# Remote usage: heroku run rake verifications:batch_withdrawal < /local/path/to/cert_batch.csv

namespace :verifications do

  desc "Quietly withdraws batch of eligibility certificates (without sending notification emails)"

  task :batch_withdrawal, [:filename] => :environment do |task, args|

    require 'csv'

    puts "Beginning batch certificate withdrawal..."

    # Ingest relevant data from batch csv file
    CSV.parse(STDIN.read, headers: true).each do |row|
      item = row.to_hash.symbolize_keys
      
      unless item[:certificate_code].blank?
        cert_code = item[:certificate_code].upcase
        verification = Verification.find_by(identifier: cert_code)

        if verification.blank?
          puts "#{cert_code} cannot be withdrawn, it does not exist"
          # Cert code xyz does not exist
        elsif verification.withdrawn?
          puts "#{cert_code} cannot be withdrawn, it already was"
        elsif verification.denied? || verification.ignored?
          puts "#{cert_code} cannot be withdrawn, it was #{verification.status}"
        elsif verification.pending?
          puts "#{cert_code} cannot be withdrawn, it is pending"
        elsif verification.eligible?
          if verification.update(status: :withdrawn, refusal_reason: "Quietly withdrawn in batch cleanup.", withdrawer: User.first, withdrawn_on: Time.now)
            puts "#{cert_code} was quietly withdrawn"
          else
            puts "#{cert_code} could not be withdrawn, something went wrong"
          end
        end
      end
    end
    
    puts "Process complete."
    
  end
end