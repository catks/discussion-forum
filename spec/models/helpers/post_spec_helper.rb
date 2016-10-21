module PostSpecHelpers
  def create_comments_for(post)
    FactoryGirl.create_list(:post,5,parent_id: post.id)
  end

  def create_posts
    FactoryGirl.create_list(:post,30) if Post.count < 30
  end

  def create_posts_with_comments
    posts_list = create_posts
    posts_list.each do |post|
      create_comments_for(post)
    end
  end
end
