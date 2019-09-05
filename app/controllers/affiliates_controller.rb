class AffiliatesController < ApplicationController
  
  layout "backstage"
  
  before_action :authenticate_user!,        only: [ :edit, :update ]
  before_action :ensure_staff,              only: [ :edit, :update ]
  before_action :find_affiliate,            only: [ :edit, :update ]
  
  def index
    if public_view?
      render action: "public_index", layout: "application"
    else
      authenticate_user!
      ensure_staff
    end  
  end
  
  protected
    def find_affiliate
      @affiliate = Report.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to staff_index_path
    end
    
    def public_view?
      Rails.logger.info("*********")
      Rails.logger.info(current_user == nil)

      current_user == nil
    end

  private
    def ensure_staff
      unless current_user.is_moderator? || current_user.is_admin?
        redirect_to root_url
      end
    end
  
end
