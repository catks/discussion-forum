class NotifyMailer < ApplicationMailer
  default from: 'discussion.forum321@gmail.com'

  after_action :set_notifications_as_sent
  def notifications_email(notification_mail) #Receives a NotificationMail instance as parameter
    if !notification_mail.unsent_notifications.empty?
      @notification_mail = notification_mail
      @notifications = @notification_mail.unsent_notifications
      mail(to: @notification_mail.user,subject: "Daily Notifications")
    end
  end

  private

  def set_notifications_as_sent
    @notifications&.each{ |notification| notification.sent = true }
  end
end
