class V1::PostsController < ApplicationController
  before_action :set_post,only:[:show]

  def index
    @posts = Post.root_posts.page(params[:page])
    render :json => @posts
  end

  def create
    post = Post.create(post_params)
    if post.valid?
      message = post.root_post? ? "Post #{post.title} created" : "Comment #{post.title} in #{post.root_parent.title}"
      NotificationMail.notify(users: post.root_parent.users, message: message)
    end
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
