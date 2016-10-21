module NotificationMailSpecHelpers

  def create_notification_mails
    FactoryGirl.create_list(:notification_mail,5,:with_notifications) if NotificationMail.count < 5
  end
end
