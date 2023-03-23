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
        verification = Verification.find_by(identifier: player_data[:certificate_code])
        certificate_code = {certificate_code: player_data[:certificate_code]}

        # Check if cert code exists, look up state of request, and validate eligible player data with crosscheck
        if verification.blank?
          response = {response: "not_found"}
          cross_check_results << {**certificate_code, **response}
        elsif verification.denied? || verification.ignored? || verification.pending?
          response = {response: "invalid"}
          cross_check_results << {**certificate_code, **response}
        elsif verification.eligible?
          response = {response: "valid"}
          validation_results = verification.validate(player_data)
          validation_results.each do |key, value|
            if value == "miss"
              response = {response: "inconsistent"}
            end
          end
          cross_check_results << {**certificate_code, **response, **validation_results, **verification.validated_details}
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