class AdminController < ApplicationController
  layout 'backstage'
    
  before_action :authenticate_user!
  before_action :ensure_admin
  
  def index
  end
  
  private
    def ensure_admin
      if !current_user.is_admin?
        redirect_to root_url
      end
    end
  
end
