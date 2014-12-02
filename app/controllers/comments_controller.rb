class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create!(comment_params) if current_user
    @comment.user = current_user
    @comment.save
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if ((Time.now - @comment.created_at)/3600.to_i <= 1 && current_user == @comment.user)
      @comment.destroy
      flash[:notice] = 'Comment was successfully destroyed.'
      redirect_to :back
    else
      flash[:notice] = "You can't delete this comment"
      redirect_to :back
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
