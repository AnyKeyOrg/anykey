class StaffController < ApplicationController
  
  layout "backstage"
      
  before_action :authenticate_user!
  before_action :ensure_staff

  
  def index
  end
          
  private
    def ensure_staff
      unless current_user.is_moderator? || current_user.is_admin?
        redirect_to root_url
      end
    end

end
