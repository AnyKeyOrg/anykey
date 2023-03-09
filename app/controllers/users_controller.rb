class UsersController < ApplicationController
  
  layout "backstage"
  
  before_action :authenticate_user!
  before_action :ensure_admin,          only: [ :index, :show ]
  before_action :find_user,             only: [ :show, :edit, :update, :remove_avatar ]
  before_action :ensure_owner,          only: [ :edit, :update, :remove_avatar ]
  
  def index
    @users = User.all
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      flash[:notice] = "Your profile has been successfully updated."
      redirect_to edit_user_path(@user)
    else
      flash.now[:alert] ||= ""
      @user.errors.full_messages.each do |message|
        flash.now[:alert] << message + ". "
      end
      render(action: :edit)
    end
  end
  
  def remove_avatar
    @user.image = nil
    
    if @user.save
      flash[:notice] = "Your profile has been successfully updated."
    else
      flash.now[:alert] ||= ""
      @user.errors.full_messages.each do |message|
        flash.now[:alert] << message + ". "
      end
    end
    redirect_to edit_user_path(@user)
  end
  
  protected
    def find_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to staff_index_path
    end

  private  
    def ensure_admin
      unless current_user.is_admin?
        redirect_to root_url
      end
    end
        
    def ensure_owner
      unless current_user == @user || current_user.is_admin?    
        redirect_to root_url
      end
    end
    
    def user_params
      params.require(:user).permit(:first_name, :last_name, :username, :image)
    end
  
end
