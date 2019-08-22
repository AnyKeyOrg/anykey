class ApplicationController < ActionController::Base  
  before_action :set_locale
  
  def set_locale
    begin
      I18n.locale = params[:locale] || I18n.default_locale
    rescue I18n::InvalidLocale
      I18n.locale = I18n.default_locale
    end
  end
  
  def default_url_options(options={})
    { :locale => I18n.locale }
  end
end
