class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :vote]
  before_action :post_user, only: [:edit, :update, :destroy]
  before_action :authenticate, only: [:new, :edit, :create, :update, :destroy, :vote]

  # GET /posts
  # GET /posts.json
  def index
    if params[:sort] == 'active'
      @posts = Post.active_posts
    elsif params[:sort] == 'popular'
      @posts = Post.popular
    else
      @posts = Post.all
    end
    respond_to do |format|
      format.json {render json: @posts, except: [:updated_at, :user_id], :include => {:user => {:only => :name}}}
      format.html
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @posts = Post.recent
    respond_to do |format|
      format.json {render json: @post, except: [:updated_at, :user_id], :include => {:user => {:only => :name}}}
      format.html
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user if current_user

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def vote
    rate_value = params[:value] == 'like' ? 1 : -1
    if  check_for_vote?
      @votes = PostVotes.create(user_id: current_user.id, post_id: @post.id, value: rate_value)
      flash[:notice] = "You rated #{@post.user.name} post: #{params[:value]}"
      if @votes.save
        @post.rating += rate_value
        @post.save
        redirect_to :back
      end
    else
      flash[:notice] = 'You already rated this post'
      redirect_to :back
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, :tags)
    end

   def post_user
     if current_user != @post.user
      redirect_to post_path
     end
   end

  def check_for_vote?
    @rated_by = PostVotes.where(user_id: current_user.id, post_id: params[:id])
    @rated_by.blank? && current_user != @post.user
  end

end
