require 'rails_helper'
require_relative '../../models/helpers/post_spec_helper.rb'
RSpec.describe V1::PostsController, type: :controller do
  include PostSpecHelpers

  describe "GET #index" do
    let(:all_root_posts_in_order){Post.root_posts.order("updated_at desc")}
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    context "without params" do
      it "returns all root posts" do
        get :index
        expect(response.body).to eq(all_root_posts_in_order.to_json)
      end
    end

    context "with pagination" do
      before(:all){create_posts}
      it "returns root posts for specific page" do
        get :index,params: {page:2}
        expect(response.body).to eq(Post.root_posts.page(2).to_json)
      end
    end
  end

  describe "POST #create" do
    it "returns http success" do
      post :create, params:{post: attributes_for(:post)}
      expect(response).to have_http_status(:success)
    end

    it "create a new post" do
      expect{post :create, params:{post: attributes_for(:post)}}.to change{Post.count}.by(1)
    end

    it "can't create post with invalid attributes" do
      expect{post :create, params:{post: attributes_for(:invalid_post)}}.to_not change{Post.count}
    end
  end

  describe "GET #show" do
    let(:sample_post){Post.all.sample}
    it "returns http success" do
      get :show, params: {id:1}
      expect(response).to have_http_status(:success)
    end

    it "returns comments of the post" do
      create_comments_for(sample_post) if sample_post.comments.empty?
      get :show, params: {id: sample_post.id}
      comments = JSON.parse(response.body)["comments"]
      expect(comments.to_json).to eq(sample_post.comments.to_json)
    end

  end

end
