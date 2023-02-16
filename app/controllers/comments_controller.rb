class CommentsController < ApplicationController

  def create
    @comment = Comment.new(comment_params)
    @comment.commenter = current_user
    respond_to do |format|
      if @comment.save
        format.js
      else
        #TODO if not saved give alert?
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :report_id)
  end
end
