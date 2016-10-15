class Post < ApplicationRecord
  belongs_to :parent, required: false , class_name: 'Post', foreign_key: 'parent_id'
  has_many :comments, class_name: 'Post', foreign_key: 'parent_id'
  scope :root_posts, -> {where(parent_id:nil)}
  attr_readonly :title,:body,:author
  before_destroy { |record| raise ActiveRecord::ReadOnlyRecord }
  before_update :prevent_update

  def root_post?
    parent_id.nil?
  end

  private
  def prevent_update
    return true if self.changed == ["parent_id"]
    self.changed.each do |field|
      self.errors.add(field, "Cannot update a #{ self.to_s }")
    end
    throw(:abort)
  end
end
