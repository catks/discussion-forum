class V1::PostsController < ApplicationController
  before_action :set_post,only:[:show]

  def index
    @posts = Post.root_posts.page(params[:page])
    render :json => @posts
  end

  def create
    Post.create(post_params)
  end

  def show
    render :json => @post, include: :comments
  end

  private

  def post_params
    params.require(:post).permit(:title,:author,:body,:parent_id)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
