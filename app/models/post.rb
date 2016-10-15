class Post < ApplicationRecord
  include CensorConcern
  belongs_to :parent, required: false , class_name: 'Post', foreign_key: 'parent_id'
  has_many :comments, class_name: 'Post', foreign_key: 'parent_id'
  scope :root_posts, -> {where(parent_id:nil)}
  attr_readonly :title,:body,:author
  before_destroy { |record| raise ActiveRecord::ReadOnlyRecord }
  before_update :prevent_update
  before_create :censor_post_fields
  validates :title,:body,:author,presence: true

  def root_post?
    parent_id.nil?
  end

  def censor_post_fields
    self.title = censor(self.title)
    self.body = censor(self.body)
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
