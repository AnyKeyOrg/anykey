module DeviseHelper
  
  # Overrides standard helper to function like other site alerts
  def devise_error_messages!
    flash.now[:alert] ||= ""
    resource.errors.full_messages.each do |message|
      flash.now[:alert] << message + ". "
    end
  end
    
end