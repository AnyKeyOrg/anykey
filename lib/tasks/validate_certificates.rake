# This task imports past pledges from a CSV file using STDIN
# It will work on Heroku as well as in development
# Local usage: rake verifications:validate_certificates < /local/path/to/player_data.csv
# Remote usage: heroku run rake verifications:validate_certificates --no-tty < /local/path/to/player_data.csv > /local/path/for/results.csv

namespace :verifications do

  desc "Validates batch of eligibility certificates by crosschecking player data from csv"

  task :validate_certificates, [:filename] => :environment do |task, args|

    require 'csv'

    cross_check_results = []

    # Ingest relevant data from batch csv file
    CSV.parse(STDIN.read, headers: true).each do |row|
      player_data = row.to_hash.symbolize_keys
      
      unless player_data[:certificate_code].blank?
        v = Verification.find_by(identifier: player_data[:certificate_code])
        c = {certificate_code: player_data[:certificate_code]}
        not_valid = {full_name: "invalid", email: "invalid", discord_username: "invalid", player_id: "invalid"}

        # Check if cert code exists, look up state of request, and validate eligible player data with crosscheck
        if v.blank?
          r = {response: "not_found"}
          cross_check_results << {**c, **r, **not_valid}
        elsif v.denied? || v.ignored? || v.pending?
          r = {response: "invalid"}
          cross_check_results << {**c, **r, **not_valid}
        elsif v.eligible?
          r = {response: "valid"}
          d = v.validate(player_data)
          d.each do |key, value|
            if value == "inconsistent"
              r = {response: "inconsistent"}
            end
          end
          cross_check_results << {**c, **r, **d}
        end
      end
    end

    # Formulate csv reponse of crosschecks
    headers = cross_check_results.flat_map(&:keys).uniq
    csv_response = CSV.generate(headers: true) do |csv|
      csv << headers
      cross_check_results.each do |result|
        csv << result.values_at(*headers)
      end
    end

    # Print csv response to stdout
    puts csv_response

  end

end