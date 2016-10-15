# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'factory_girl_rails'

#Create the root posts
10.times{FactoryGirl.create(:post)}
Post.root_posts.each do |post|
  #Create 5 comments for each root thread
  5.times{FactoryGirl.create(:post,parent_id: post.id)}
end
