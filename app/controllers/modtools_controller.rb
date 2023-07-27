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

    # Ensure uploaded file is actually CSV

    # Process uploaded CSV file
    logger.info "******************************************************************"
    CSV.open(params[:validate_certs_input_csv].path, headers: true).each do |row|
      logger.info row.to_hash.symbolize_keys
    end
    logger.info "******************************************************************"
    
    # Return JSON object with results if all is good
    # render :json => {}, :status => 200
    
    # If glitched, throw an error
    render :json => {:error => 'The request must contain a CSV file', :code => '400'}, :status => 400    

  end
   
  private
    def ensure_staff
      unless current_user.is_moderator? || current_user.is_admin?
        redirect_to root_url
      end
    end
  
end
