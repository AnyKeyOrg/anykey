class StoriesController < ApplicationController
  
  layout "backstage"
  
  before_action :authenticate_user!,        only: [ :new, :create, :edit, :update ]
  before_action :ensure_admin,              only: [ :new, :create, :edit, :update ]
  before_action :find_story,                only: [ :edit, :update ]
  around_action :display_timezone
  around_action :adjust_timezone,           only: [ :create, :update ]
  
  def index    
    if public_view?
      @stories = Story.published.order(published_on: :desc)
      render action: "public_index", layout: "application"
    else
      @stories = Story.all.order(created_at: :desc)
      authenticate_user!
      ensure_admin
    end
  end
  
  def new
    @story = Story.new
  end
  
  def create
    @story = Story.new(story_params)
  
    if @story.save
      flash[:notice] = "You've added a new story."
      redirect_to stories_path(staff: true)
    else      
      flash.now[:alert] ||= ""
      @story.errors.full_messages.each do |message|
        flash.now[:alert] << message + ". "
      end      
      render(action: :new)
    end
  end
  
  def edit
  end
  
  def update
    if @story.update(story_params)
      flash[:notice] = "Your successfully updated the story."
      redirect_to edit_story_path(@story)
    else
      flash.now[:alert] ||= ""
      @story.errors.full_messages.each do |message|
        flash.now[:alert] << message + ". "
      end
      render(action: :edit)
    end
  end
  
  def changemakers
    render action: "changemakers", layout: "application"
  end
  
  protected
    def find_story
      @story = Story.find(params[:id])
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
    
    def adjust_timezone
      timezone = Time.find_zone( cookies[:browser_timezone] )
      Time.use_zone(timezone) { yield }
    end
    
    def display_timezone
      timezone = Time.find_zone( cookies[:browser_timezone] )
      Time.use_zone(timezone) { yield }
    end
    
    def story_params
      params.require(:story).permit(:headline, :description, :link, :published, :published_on_date, :published_on_time, :image)
    end
    
end
