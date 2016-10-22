class NotificationMail < ApplicationRecord
  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  has_many :notifications
  validates_format_of :user, with: EMAIL_REGEX
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

  def mark_all_as_sent!
    self.unsent_notifications.each do |notification|
      notification.sent = true
      notification.save!
    end
  end

  def count
    self.notifications.size
  end

  def add(notification_message)
    Notification.create(message: notification_message,notification_mail_id: self.id)
  end

  def self.notify(message:,user: nil ,users: nil)
    if user
      NotificationMail.mail_of(user).add(message)
    elsif users
      users.each do |u|
        NotificationMail.mail_of(u).add(message)
      end
    else
      raise "notify must receives either user or users to notify"
    end
  end

  def self.mail_of(user)
    raise ActiveRecord::RecordInvalid if !user.match EMAIL_REGEX
    NotificationMail.find_by_user(user) || NotificationMail.create(user: user)
  end
end
