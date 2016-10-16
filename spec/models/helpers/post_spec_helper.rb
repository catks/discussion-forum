module PostSpecHelpers
  def create_comments_for(post)
    FactoryGirl.create_list(:post,5,parent_id: post.id)
  end

  def create_posts
    FactoryGirl.create_list(:post,30) if Post.count < 30
  end
end
