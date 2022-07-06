class CommentsController < ApplicationController

  def create
    @comment = Comment.new(comment_params)
    @comment.commenter = current_user
    @comment.save

    respond_to do |format|
      format.js
    end

  end

  private

  def comment_params
    params.require(:comment).permit(:body, :report_id)
  end
end
