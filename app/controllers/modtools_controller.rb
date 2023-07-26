class ModtoolsController < ApplicationController
  
  layout "backstage"
      
  before_action :authenticate_user!
  before_action :ensure_staff

  
  def certificate_validation
  end
          
  private
    def ensure_staff
      unless current_user.is_moderator? || current_user.is_admin?
        redirect_to root_url
      end
    end
  
end
