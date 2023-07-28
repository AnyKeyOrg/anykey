class ModtoolsController < ApplicationController
  
  require 'csv'

  layout "backstage"
      
  before_action :authenticate_user!
  before_action :ensure_staff
  
  # GET: Show mod view with one page miniapp
  def cert_validation
  end

  # POST: Crosscheck batch from CSV file and return results
  def validate_certs
    respond_to :json

    # Ensure request includes a CSV file
    if params[:validate_certs_input_csv].blank? || params[:validate_certs_input_csv].content_type != 'text/csv'
      render :json => {:error => 'The request must contain a CSV file', :code => '400'}, :status => 400
    else
      # Process CSV file
      cross_check_results = []
      
      CSV.open(params[:validate_certs_input_csv].path, headers: true).each do |row|
        player_data = row.to_hash.symbolize_keys
      
        unless player_data[:certificate_code].blank?
          verification = Verification.find_by(identifier: player_data[:certificate_code])
          certificate_code = {certificate_code: player_data[:certificate_code]}

          # Check if cert code exists, look up state of request, and validate eligible player data with crosscheck
          # Note: uses ** double splat trick to easily merge hashes
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
       
      # Formulate CSV reponse of crosschecks
      headers = cross_check_results.flat_map(&:keys).uniq
      csv_response = CSV.generate(headers: true) do |csv|
        csv << headers
        cross_check_results.each do |result|
          csv << result.values_at(*headers)
        end
      end
      
      render :json => {results: cross_check_results}, :status => 200
    end
    
  end
   
  private
    def ensure_staff
      unless current_user.is_moderator? || current_user.is_admin?
        redirect_to root_url
      end
    end
  
end
