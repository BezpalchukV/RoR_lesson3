class FavoritePostsController < ApplicationController
  before_action :set_post, only: [:create, :destroy]

  def index
    @user = current_user if current_user
    @posts = @user.favorite_posts
    respond_to do |format|
      format.json {render json: @posts}
      format.html
    end
  end

  def create
    if Favorite.create(favorited: @post, user: current_user)
      redirect_to :back, notice: 'Post has been added to favorites'
    else
      redirect_to :back, alert: 'Something went wrong...*sad panda*'
    end
  end

  def destroy
    Favorite.where(favorited_id: @post.id, user_id: current_user.id).first.destroy
    redirect_to @post, notice: 'Post is no longer in favorites'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

end
