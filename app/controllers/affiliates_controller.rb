class AffiliatesController < ApplicationController
  
  layout "backstage"
  
  before_action :authenticate_user!,        only: [ :new, :create, :edit, :update ]
  before_action :ensure_admin,              only: [ :new, :create, :edit, :update ]
  before_action :find_affiliate,            only: [ :edit, :update ]
  
  def index
    @affiliates = Affiliate.all.order(name: :asc)
    
    if public_view?
      render action: "public_index", layout: "application"
    else
      authenticate_user!
      ensure_admin
    end  
  end
  
  def new
    @affiliate = Affiliate.new
  end
  
  def create
    @affiliate = Affiliate.new(affiliate_params)
  
    if @affiliate.save
      flash[:notice] = "You've added a new affilate."
      redirect_to affiliates_path(staff: true)
    else      
      flash.now[:alert] ||= ""
      @affiliate.errors.full_messages.each do |message|
        flash.now[:alert] << message + ". "
      end      
      render(action: :new)
    end
  end
  
  def edit
  end
  
  def update
    if @affiliate.update(affiliate_params)
      flash[:notice] = "Your successfully updated the affiliate."
      redirect_to edit_affiliate_path(@affiliate)
    else
      flash.now[:alert] ||= ""
      @affiliate.errors.full_messages.each do |message|
        flash.now[:alert] << message + ". "
      end
      render(action: :edit)
    end
  end
  
  protected
    def find_affiliate
      @affiliate = Affiliate.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to staff_index_path
    end
    
    def public_view?
      params[:staff].blank?      
    end

  private
    def ensure_admin
      unless current_user.is_admin?
        redirect_to root_url
      end
    end
    
    def affiliate_params
      params.require(:affiliate).permit(:name, :title, :bio, :website, :twitch, :twitter, :facebook, :instagram, :youtube, :discord, :mixer, :image)
    end
  
end
