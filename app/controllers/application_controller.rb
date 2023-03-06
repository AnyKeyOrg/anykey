class ApplicationController < ActionController::Base
  
  layout :choose_layout
  
  before_action :set_locale
  
  def set_locale
    begin
      I18n.locale = params[:locale] || I18n.default_locale
    rescue I18n::InvalidLocale
      I18n.locale = I18n.default_locale
    end
  end
  
  def default_url_options(options={})
    { locale: (I18n.locale unless I18n.locale == I18n.default_locale ) } 
  end
  
  def after_sign_in_path_for(user)
    staff_index_path
  end
  
  private
    def choose_layout
      if devise_controller?
        "backstage"
      else
        "application"
      end
    end

end
