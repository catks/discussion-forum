class NotificationMail < ApplicationRecord
  has_many :notifications

  validates_format_of :user, with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :user,uniqueness: true
  def sent_notifications
    self.notifications.select{ |n| n.sent? }
  end

  def unsent_notifications
    self.notifications.select{ |n| !n.sent? }
  end

  def has_unsent_notifications?
    !unsent_notifications.empty?
  end

  def mark_all_as_sent
    self.unsent_notifications.each do |notification|
      notification.sent = true
    end
  end
end
