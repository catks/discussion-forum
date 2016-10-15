module PostSpecHelpers
  def create_comments_for(post)
    FactoryGirl.create_list(:post,5,parent_id: post.id)
  end
end
