require 'rails_helper'
require_relative 'helpers/post_spec_helper.rb'
RSpec.describe Post, type: :model do
  include PostSpecHelpers
  let(:post){FactoryGirl.build(:post)}
  let(:censored_post){FactoryGirl.build(:censored_post)}
  let(:existing_post){FactoryGirl.create(:post)}
  let(:root_post){existing_post}
  let(:post_attributes){FactoryGirl.attributes_for(:post)}
  let(:bad_word){BAD_WORDS.sample}
  let(:post_with_comments){FactoryGirl.create(:post,:with_comments)}
  let(:post_without_comments){FactoryGirl.create(:post)}
  let(:ok_sentence){"The secret of the world is 42"}
  let(:bad_sentence){"#{BAD_WORDS.sample} #{BAD_WORDS.sample} e super legal"}

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

  describe "Censorship" do
    it "bad words in title" do
      expect(create(:post,title: bad_word).title).to match(/\*+/)
    end
    it "bad words in body" do
      expect(create(:post,title: bad_word).title).to match(/\*+/)
    end

    it "return the same sentence if none badwords are found" do
      expect(create(:post,title: ok_sentence).title).to eq(ok_sentence)
    end

    it "return the a sentence with same size" do
      expect(create(:post,title: bad_sentence).title.size).to eq(bad_sentence.size)
    end

    it 'is case insensitive' do
      expect(create(:post,title: bad_word.capitalize).title).to match(/\*+/)
    end

  end

  describe "Pagination" do
    let(:order){"updated_at desc"}
    let(:all_posts_in_order){Post.order(order)}
    before(:all){create_posts}

    it "paginate 10 items in default configuration" do
      expect(Post.page(1).count).to eq(10)
    end

    it "is default sorted by 'updated_at desc'" do
      expect(Post.page(1)).to eq(all_posts_in_order.first(10))
    end

    it "can be sorted in another way" do
      other_sort_method = "created_at asc"
      expect(Post.page(1, order: other_sort_method)).to eq(Post.order(other_sort_method).first(10))
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
      expect(Post.last_page).to eq(all_posts_in_order.last(num_of_last_items))
    end

    it "return all posts if page is nil" do
      expect(Post.page(nil)).to eq(all_posts_in_order)
    end

    it "accepts page number as string or as a number" do
      expect(Post.page("2")).to eq(Post.page(2))
    end

  end

  describe "#users" do
    EMAIL_REGEX ||= NotificationMail::EMAIL_REGEX

    context "post with comments" do
      it "returns all users emails that either created or commentend on a post" do
        expect(post_with_comments.users).to all(match(EMAIL_REGEX))
      end
    end

    context "post without comments" do
      it "return the author email" do
        expect(post_without_comments.users).to eq([post_without_comments.author])
      end
    end

  end

  describe "#root_parent" do
    context "post is a comment" do
      it "returns the root post that a post is vinculated to" do
        comment = post_with_comments.comments.first
        expect(comment.root_parent).to eq(post_with_comments)
      end
    end

    context "post is a root post" do
      it "returns itself" do
        expect(root_post.root_parent).to eq(root_post)
      end
    end
  end

end
