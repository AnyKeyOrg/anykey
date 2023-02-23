class VerificationsController < ApplicationController
  
  def new
    @verification = Verification.new
  end
  
  def create
    @verification = Verification.new(verification_params)
  
    # TODO: set requested_on
  
    if @verification.save
      # TODO: send notification to staff
      flash[:notice] = "You've successfully submitted your eligibility verification request. Thank you."
      redirect_to root_path
    else      
      flash.now[:alert] ||= ""
      @report.errors.full_messages.each do |message|
        flash.now[:alert] << message + ". "
      end      
      render(action: :new)
    end
  end
  
  private
    def verification_params
      params.require(:verification).permit(:first_name, :last_name, :email, :discord_username, :player_id_type, :player_id, :gender, :pronouns, :photo_id, :doctors_note, :social_profile, :voice_requested, :additional_notes)
    end
  
end
