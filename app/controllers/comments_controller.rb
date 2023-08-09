class CommentsController < ApplicationController

  before_action :authenticate_user!, only: [ :create, :destroy ]
  before_action :ensure_staff,       only: [ :create, :destroy ]
  before_action :find_comment,       only: [ :destroy ]
  before_action :ensure_commenter,   only: [ :destroy ]
  around_action :display_timezone

  def create
    respond_to do |format|
      @comment = Comment.new(comment_params)
      @comment.commenter = current_user
    
      if @comment.save
        format.js
      end
    end
  end
  
  def destroy
    respond_to do |format|
      if @comment.destroy
        format.js
      end
    end
  end
  
  protected
    def find_comment
      @comment = Comment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to staff_index_path
    end

  private
    def ensure_staff
      unless current_user.is_moderator? || current_user.is_admin?
        redirect_to root_url
      end
    end
    
    def ensure_commenter
      unless current_user == @comment.commenter
        redirect_to root_url
      end
    end
    
    def display_timezone
      timezone = Time.find_zone( cookies[:browser_timezone] )
      Time.use_zone(timezone) { yield }
    end
    
    def comment_params
      params.require(:comment).permit(:body, :commentable_id, :commentable_type)
    end

end
