require 'rails_helper'
require_relative 'helpers/post_spec_helper.rb'

RSpec.describe Post, type: :model do
  include PostSpecHelpers
  let(:post){FactoryGirl.build(:post)}
  let(:censored_post){FactoryGirl.build(:censored_post)}
  let(:existing_post){FactoryGirl.create(:post)}
  let(:post_attributes){FactoryGirl.attributes_for(:post)}

  it "can be created" do
    post.save!
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

  it "censor words in blacklist" do
    
  end

end
