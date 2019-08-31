class Users::InvitationsController < Devise::InvitationsController

  before_action :ensure_admin, only: [ :new, :create ]

  def after_invite_path_for(user)
    users_path
  end
  
  def after_accept_path_for(user)
    edit_user_path(user)
  end

  private
    def ensure_admin
      unless current_user.is_admin?    
        redirect_to root_url
      end
    end
    
end