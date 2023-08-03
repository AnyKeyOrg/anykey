class ConcernsController < ApplicationController
  
  layout "backstage",                only: [ :index, :show ]
  
  before_action :authenticate_user!, only: [ :index, :show ]
  before_action :ensure_staff,       only: [ :index, :show ]
  before_action :find_concern,       only: [ :show ]
  around_action :display_timezone
  
  def index
    # per_page is a silent param to show more records per page
    if params[:per_page].present?
      per_page = params[:per_page]
    else
      per_page = 30
    end

    # f is used to filter reports by scope
    # q is used to search for keywords
    if (params[:f].present? && Concern::SORT_FILTERS.key?(params[:f].to_sym)) && params[:q].present?
      @concerns = eval("Concern."+params[:f]+".search('"+params[:q]+"').order(shared_on: :asc).paginate(page: params[:page], per_page: "+per_page.to_s+")")
      @filter_category = params[:f]
    elsif params[:f].present? && Concern::SORT_FILTERS.key?(params[:f].to_sym)
      @concerns = eval("Concern."+params[:f]+".order(shared_on: :asc).paginate(page: params[:page], per_page: "+per_page.to_s+")")
      @filter_category = params[:f]
    elsif params[:q].present?
      @concerns = Concern.all.search(params[:q]).order(shared_on: :asc).paginate(page: params[:page], per_page: per_page)
      @filter_category = "all"
    else
      @concerns = Concern.open.order(shared_on: :asc).paginate(page: params[:page], per_page: per_page)
      @filter_category = "open"
    end
  end

  def show
  end
    
  def new
    @concern = Concern.new
  end

  def create
    @concern = Concern.new(concern_params)

    if @concern.save
                  
      # TODO: send notification to staff
      
      # Email confirmation to concerned player
      # ConcernMailer.confirm_receipt(@concern).deliver_now
      
      flash[:notice] = "You've successfully submitted your concern. Thank you."
      redirect_to root_path
    else
      flash.now[:alert] ||= ""
      @concern.errors.full_messages.each do |message|
        flash.now[:alert] << message + ". "
      end
      render(action: :new)
    end
  end
  
  protected
    def find_concern
      @concern = Concern.find(params[:id])
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
    
    def concern_params
      params.require(:concern).permit(:concerning_player_id, :concerning_player_id_type, :background, :description, :recommended_response, :concerned_email, :concerned_cert_code, screenshots: [])
    end
    
end
