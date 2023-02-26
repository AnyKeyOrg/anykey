class VerificationsController < ApplicationController
  
  layout "backstage",                       only: [ :index, :show, :eligible, :denied ]
  
  before_action :authenticate_user!,        only: [ :index, :show, :ignore, :unignore, :eligible, :denied, :verify, :deny ]
  before_action :ensure_staff,              only: [ :index, :show, :ignore, :unignore, :eligible, :denied, :verify, :deny ]
  before_action :find_verification,         only: [ :show, :ignore, :unignore, :eligible, :denied, :verify, :deny ]
  around_action :display_timezone
  
  def index
    # f is used to filter reports by scope
    if params[:f].present? && Verification::SORT_FILTERS.key?(params[:f].to_sym)
      @verifications = eval("Verification."+params[:f]+".all.order(requested_on: :asc).paginate(page: params[:page], per_page: 30)")
      @filter_category = params[:f]
    else
      @verifications = Verification.pending.all.order(requested_on: :asc).paginate(page: params[:page], per_page: 30)      
      @filter_category = "pending"
    end
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
        flash[:notice] = "You ignored the eligibility verification request from #{@verification.full_name}."
      end
    end      
    redirect_to verifications_path
  end
  
  def unignore
    if @verification.ignored? # Reasonability check to only allow ignored requests to be unignored
      if @verification.update(status: :pending, reviewer: nil, reviewed_on: nil)
        flash[:notice] = "You unignored the eligibility verification request from #{@verification.full_name}. It can now be reviewed again."
        redirect_to verification_path(@verification) and return
      end
    end
    redirect_to verifications_path
  end

  def eligible
  end
  
  def denied
  end
  
  def verify    
    if @verification.pending? # Reasonability check to only allow pending requests to be denied
      if @verification.update(status: :eligible, reviewer: current_user, reviewed_on: Time.now)
        # TODO: Send certification email
        # TODO: Purge attachments
        flash[:notice] = "You certified the eligibility verification request from #{@verification.full_name}."
      else
        flash.now[:alert] ||= ""
        @verification.errors.full_messages.each do |message|
          flash.now[:alert] << message + ". "
        end
        render(action: :eligible, layout: "backstage") and return
      end
    end      
    redirect_to verifications_path
  end
  
  def deny
    if @verification.pending? # Reasonability check to only allow pending requests to be denied
      if @verification.update(status: :denied, denial_reason: params[:verification][:denial_reason], reviewer: current_user, reviewed_on: Time.now)
        # TODO: Send denial email
        # TODO: Purge attachments
        flash[:notice] = "You denied the eligibility verification request from #{@verification.full_name}."
      else
        flash.now[:alert] ||= ""
        @verification.errors.full_messages.each do |message|
          flash.now[:alert] << message + ". "
        end
        render(action: :denied, layout: "backstage") and return
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
