require 'rails_helper'
require_relative 'helpers/post_spec_helper.rb'
RSpec.describe Post, type: :model do
  include PostSpecHelpers
  let(:post){FactoryGirl.build(:post)}
  let(:censored_post){FactoryGirl.build(:censored_post)}
  let(:existing_post){FactoryGirl.create(:post)}
  let(:post_attributes){FactoryGirl.attributes_for(:post)}
  let(:bad_word){BAD_WORDS.sample}

  it "can be created with valid parameters" do
    post.save!
  end

  it "can't be created without title" do
    expect{build(:post,title:nil).save!}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "can't be created without body" do
    expect{build(:post,body:nil).save!}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "can't be created without author" do
    expect{build(:post,author:nil).save!}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "title can't be update" do
    expect{existing_post.update!(title: post_attributes[:title])}.to raise_error(ActiveRecord::RecordNotSaved)
  end

  it "body can't be update" do
    expect{existing_post.update!(body: post_attributes[:body])}.to raise_error(ActiveRecord::RecordNotSaved)
  end

  it "author can't be update" do
    expect{existing_post.update!(author: post_attributes[:author])}.to raise_error(ActiveRecord::RecordNotSaved)
  end

  it "can't be destroyed" do
    expect{existing_post.destroy!}.to raise_error(ActiveRecord::ReadOnlyRecord)
  end

  it "can have comments" do
    create_comments_for(existing_post)
    expect(existing_post.comments).not_to be_empty
  end

  describe "censor" do
    it "bad words in title" do
      expect(create(:post,title: bad_word).title).to match(/\*+/)
    end
    it "bad words in body" do
      expect(create(:post,title: bad_word).title).to match(/\*+/)
    end
  end

  describe "Pagination" do

    before(:all) do
      create_posts
    end

    it "paginate 10 items in default configuration" do
      expect(Post.page(1).count).to eq(10)
    end

    it "can paginate in another number" do
      Post.max_items_for_page = 5
      expect(Post.page(2).count).to eq(5)
    end

    it "return a array of pages" do
      expect(Post.pages).to all(be_an(Integer))
    end

    it "return the correct number of pages" do
      expect((Post.count / Post.max_items_for_page.to_f).ceil).to eq(Post.pages.last)
    end

    it "return the last page" do
      num_of_last_items = Post.last_page.count
      expect(Post.last_page).to eq(Post.last(num_of_last_items))
    end

    it "return all if page is nil" do
      expect(Post.page(nil)).to eq(Post.all)
    end

    it "accepts page number as string or as a number" do
      expect(Post.page("2")).to eq(Post.page(2))
    end

  end

end
