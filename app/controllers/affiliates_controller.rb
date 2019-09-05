class AffiliatesController < ApplicationController
  
  layout "backstage"
  
  before_action :authenticate_user!,        only: [ :edit, :update ]
  before_action :ensure_staff,              only: [ :edit, :update ]
  before_action :find_affiliate,            only: [ :edit, :update ]
  
  def index
    @affiliates = Affiliate.all
    
    if public_view?
      render action: "public_index", layout: "application"
    else
      authenticate_user!
      ensure_staff
    end  
  end
  
  def new
    @affiliate = Affiliate.new
  end
  
  def create
    @affiliate = Affiliate.new(affiliate_params)
  
    if @affiliate.save
      flash[:notice] = "You've added a new affilate."
      redirect_to affiliates_path
    else      
      flash.now[:alert] ||= ""
      @affiliate.errors.full_messages.each do |message|
        flash.now[:alert] << message + ". "
      end      
      render(action: :new)
    end
  end
  
  protected
    def find_affiliate
      @affiliate = Report.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to staff_index_path
    end
    
    def public_view?
      current_user == nil
    end

  private
    def ensure_staff
      unless current_user.is_moderator? || current_user.is_admin?
        redirect_to root_url
      end
    end
    
    def affiliate_params
      params.require(:affiliate).permit(:name, :title, :bio, :website, :twitch, :twitter, :facebook, :instagram, :youtube, :image)
    end
  
end
