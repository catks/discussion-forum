require "rails_helper"

RSpec.describe NotifyMailer, type: :mailer do
  let(:notification_mail_with_notifications){FactoryGirl.create(:notification_mail,:with_notifications)}
  let(:notification_mail_without_notifications){FactoryGirl.create(:notification_mail)}

  context "User has unsent notifications" do
    it 'sends the email with new notifications' do
      expect { NotifyMailer.notifications_email(notification_mail_with_notifications).deliver_now }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "mark all unsent notifications as sent after sending the email" do
      expect { NotifyMailer.notifications_email(notification_mail_with_notifications).deliver_now }
        .to change { notification_mail_with_notifications.unsent_notifications.size }.to(0)

    end
  end

  context "User only has sent notifications" do
    it "does not send a email" do
      notification_mail_with_notifications.mark_all_as_sent!
      expect { NotifyMailer.notifications_email(notification_mail_with_notifications).deliver_now }
        .to_not change { ActionMailer::Base.deliveries.count }
    end
  end

  context "User don't has unsent messages" do
    it "does not send a email" do
      expect { NotifyMailer.notifications_email(notification_mail_without_notifications).deliver_now }
        .to_not change { ActionMailer::Base.deliveries.count }
    end
  end

end
