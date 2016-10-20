class V1::PostsController < ApplicationController
  def index
    @posts = Post.root_posts.page(params[:page])
    render :json => @posts
  end

  def create
  end

  def show
  end

  private

  def post_params
    params.require(:post).permit(:title,:author,:body,:parent_id)
  end
end
