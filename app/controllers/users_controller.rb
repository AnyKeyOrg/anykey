class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user,             only: [ :edit, :update ]
  before_action :ensure_owner,          only: [ :edit, :update ]
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:notice] = "Successfully updated #{@user.display_name}'s profile."
      redirect_to staff_index_path
    else
      flash.now[:alert] ||= ""
      @user.errors.full_messages.each do |message|
        flash.now[:alert] << message + ". "
      end
      render(:action => :edit)
    end
  end
  
  protected
    def find_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to staff_index_path
    end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :username, :image)
    end
        
    def ensure_owner
      unless current_user == @user || current_user.is_admin?    
        redirect_to root_url
      end
    end
  
end
