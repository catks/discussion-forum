require 'rails_helper'
require_relative '../../models/helpers/post_spec_helper.rb'
RSpec.describe V1::PostsController, type: :controller do
  include PostSpecHelpers

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    context "without params" do
      it "returns all root posts" do
        get :index
        expect(response.body).to eq(Post.root_posts.to_json)
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
      post :create
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, params: {id:1}
      expect(response).to have_http_status(:success)
    end
  end

end
