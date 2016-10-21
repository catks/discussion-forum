class Notification < ApplicationRecord
  belongs_to :notification_mail
  validates :message,presence:true,allow_blank: false
end
