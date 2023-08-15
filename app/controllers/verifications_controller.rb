class VerificationsController < ApplicationController

  layout "backstage",                only: [ :index, :show, :verify_eligibility, :deny_eligibility, :withdraw_eligibility ]
  
  skip_before_action :verify_authenticity_token, only: [ :watch, :unwatch ]
  
  before_action :authenticate_user!, only: [ :index, :show, :verify_eligibility, :deny_eligibility, :withdraw_eligibility,
                                            :verify, :deny, :ignore, :withdraw, :voucher, :resend_cert, :watch, :unwatch ]
  before_action :ensure_staff,       only: [ :index, :show, :verify_eligibility, :deny_eligibility, :withdraw_eligibility,
                                            :verify, :deny, :ignore, :withdraw, :voucher, :resend_cert, :watch, :unwatch ]
  before_action :find_verification,  only: [ :show, :verify_eligibility, :deny_eligibility, :withdraw_eligibility,
                                            :verify, :deny, :ignore, :withdraw, :voucher, :resend_cert, :watch, :unwatch ]
  around_action :display_timezone
  
  def index
    # f is used to filter reports by scope
    # q is used to search for keywords
    # o is used to toggle ordering
    if params[:f].present? && Verification::SORT_FILTERS.key?(params[:f].to_sym)
      @filter_category = params[:f]
    elsif params[:q].present?
      @filter_category = "all"
    else
      @filter_category = "pending"
    end
    
    if params[:o].present? && params[:o] == "asc"
      @ordering = "asc"
    else
      @ordering = "desc"
    end
    
    if params[:q].present?
      @pagy, @verifications = eval("pagy(Verification.#{@filter_category}.search('#{params[:q]}').order(requested_on: :#{@ordering}))")
    else
      @pagy, @verifications = eval("pagy(Verification.#{@filter_category}.order(requested_on: :#{@ordering}))")
    end
  end

  def show
    @related_requests = @verification.related_requests
  end

  def new
    @verification = Verification.new
  end

  def create
    @verification = Verification.new(verification_params)

    if @verification.save
      # TODO: send notification to staff

      # Email confirmation to requester
      if @verification.voice_requested
        VerificationMailer.confirm_request_voice(@verification).deliver_now
      else
        VerificationMailer.confirm_request(@verification).deliver_now
      end

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

  def verify_eligibility
  end
  
  def deny_eligibility
  end
  
  def withdraw_eligibility
  end
  
  def verify
    if @verification.pending? # Reasonability check to only allow pending requests to be denied
      if @verification.update(status: :eligible, reviewer: current_user, reviewed_on: Time.now)

        # Email certificate to requester
        VerificationMailer.verify_request(@verification).deliver_now

        # Purge attachments
        @verification.photo_id.purge
        @verification.doctors_note.purge

        flash[:notice] = "You certified the eligibility verification request from #{@verification.full_name}."
      else
        flash.now[:alert] ||= ""
        @verification.errors.full_messages.each do |message|
          flash.now[:alert] << message + ". "
        end
        render(action: :verify_eligibility, layout: "backstage") and return
      end
    end      
    redirect_to verifications_path
  end
  
  def deny
    if @verification.pending? # Reasonability check to only allow pending requests to be denied
      if @verification.update(status: :denied, refusal_reason: params[:verification][:refusal_reason], reviewer: current_user, reviewed_on: Time.now)

        # Email denial to requester
        VerificationMailer.deny_request(@verification).deliver_now

        # Purge attachments
        @verification.photo_id.purge
        @verification.doctors_note.purge

        flash[:notice] = "You denied the eligibility verification request from #{@verification.full_name}."
      else
        flash.now[:alert] ||= ""
        @verification.errors.full_messages.each do |message|
          flash.now[:alert] << message + ". "
        end
        render(action: :deny_eligibility, layout: "backstage") and return
      end
    end
    redirect_to verifications_path
  end
  
  def ignore
    if @verification.pending? # Reasonability check to only allow pending requests to be ignored
      if @verification.update(status: :ignored, reviewer: current_user, reviewed_on: Time.now)

        # Purge attachments
        @verification.photo_id.purge
        @verification.doctors_note.purge

        flash[:notice] = "You ignored the eligibility verification request from #{@verification.full_name}."
      end
    end
    redirect_to verifications_path
  end
  
  def withdraw
    if @verification.eligible? # Reasonability check to only allow eligible requests to be withdrawn
      if @verification.update(status: :withdrawn, refusal_reason: params[:verification][:refusal_reason], withdrawer: current_user, withdrawn_on: Time.now)

        # Email withdrawal to requester
        VerificationMailer.withdraw_certificate(@verification).deliver_now

        flash[:notice] = "You withdrew #{@verification.full_name}'s eligibility certificate."
      else
        flash.now[:alert] ||= ""
        @verification.errors.full_messages.each do |message|
          flash.now[:alert] << message + ". "
        end
        render(action: :withdraw_eligibility, layout: "backstage") and return
      end
    end
    redirect_to verifications_path
  end
  
  # Shows original email view that user received
  def voucher
    if !@verification.eligible? # Reasonability check to only allow eligible requests to be vouchered
      redirect_to verifications_path
    end
    render layout: false
  end

  def resend_cert
    if @verification.eligible? # Reasonability check to only allow eligible requests to have certificates resent

      # Email copy of certificate to player
      VerificationMailer.resend_certificate(@verification).deliver_now

      flash[:notice] = "You resent a copy of #{@verification.full_name}'s eligibility certificate."
    end
    redirect_to verifications_path
  end
  
  def watch
    respond_to do |format|
      if @verification.update(watched: true)
        format.js
      end
    end
  end

  def unwatch
    respond_to do |format|
      if @verification.update(watched: false)
        format.js
      end
    end
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
