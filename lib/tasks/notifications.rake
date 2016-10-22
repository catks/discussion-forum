# lib/tasks/notifications.rake

namespace :notifications do
  namespace :send do
    desc "Send Emails to all users that have unsent notifications"
    task :unsent => :environment do
      NotificationMail.with_unsent_notifications.each do |notification_mail|
        NotifyMailer.notifications_email(notification_mail).deliver_now
      end
    end
  end
end
