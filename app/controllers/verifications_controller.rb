class VerificationsController < ApplicationController
  
  layout "backstage",                       only: [ :index, :show ]
  
  before_action :authenticate_user!,        only: [ :index, :show, :ignore, :unignore ]
  before_action :ensure_staff,              only: [ :index, :show, :ignore, :unignore ]
  before_action :find_verification,         only: [ :show, :ignore, :unignore ]
  around_action :display_timezone
  
  def index
    @verifications = Verification.all.order(requested_on: :desc)
  end
  
  def show
  end
  
  def new
    @verification = Verification.new
  end
  
  def create
    @verification = Verification.new(verification_params)
    
    if @verification.save
      # TODO: send notification to staff
      flash[:notice] = "You've successfully submitted your eligibility verification request. Thank you."
      redirect_to root_path
    else
      flash.now[:alert] ||= ""
      @verification.errors.full_messages.each do |message|
        flash.now[:alert] << message + ". "
      end
      render(action: :new)
    end
  end
  
  def ignore
    if @verification.pending? # Reasonability check to only allow pending requests to be ignored
      if @verification.update(status: :ignored, reviewer: current_user, reviewed_on: Time.now)
        flash[:notice] = "You ignored the verification request from #{@verification.full_name}."
      end
    end      
    redirect_to verifications_path
  end
  
  def unignore
    if @verification.ignored? # Reasonability check to only allow ignored requests to be unignored
      if @verification.update(status: :pending, reviewer: nil, reviewed_on: nil)
        flash[:notice] = "You unignored the verification request from #{@verification.full_name}. It can now be reviewed again."
        redirect_to verification_path(@verification) and return
      end
    end
    redirect_to verifications_path
  end
    
  protected
    def find_verification
      @verification = Verification.find_by(identifier: params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to staff_index_path
    end

  private
    def ensure_staff
      unless current_user.is_moderator? || current_user.is_admin?
        redirect_to root_url
      end
    end
    
    def display_timezone
      timezone = Time.find_zone( cookies[:browser_timezone] )
      Time.use_zone(timezone) { yield }
    end
    
    def verification_params
      params.require(:verification).permit(:first_name, :last_name, :email, :discord_username, :player_id_type, :player_id, :gender, :pronouns, :photo_id, :doctors_note, :social_profile, :voice_requested, :additional_notes)
    end
    
end
