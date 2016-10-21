require 'rails_helper'
require_relative 'helpers/notification_mail_spec_helper.rb'

RSpec.describe NotificationMail, type: :model do
  include NotificationMailSpecHelpers
  before(:all){create_notification_mails}
  after(:all){delete_random_emails} #Delete new emails created by let 'new_email'

  let(:valid_notification_mail){FactoryGirl.build(:notification_mail)}
  let(:mail_with_notifications){FactoryGirl.create(:notification_mail, :with_notifications)}
  let(:existing_email){NotificationMail.all.sample.user}
  let(:new_email){"random#{Random.new.rand(1000)}@mail.com"}
  let(:invalid_email){"invalid@mail"}

  it "can be created with valid attributes" do
    valid_notification_mail.save!
  end

  it "should have a valid user email" do
    invalid_notification_mail = build(:notification_mail,user: invalid_email)
    expect{invalid_notification_mail.save!}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "can't be created with a user email that already exists" do
    invalid_notification_mail = build(:notification_mail,user: existing_email)
    expect{invalid_notification_mail.save!}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "has many notifications" do
    expect(mail_with_notifications.notifications).to all(be_an(Notification))
  end

  it "should list sent notifications" do
    expect(mail_with_notifications.sent_notifications).to eq(mail_with_notifications.notifications.select{ |n| n.sent?})
  end

  it "should list unsent notifications" do
    expect(mail_with_notifications.unsent_notifications).to eq(mail_with_notifications.notifications.select{ |n| !n.sent?})
  end

  it "should say if it have unsent notifications" do
    expect(mail_with_notifications).to have_unsent_notifications
  end

  it "can mark all notifications as sent" do
    mail_with_notifications.mark_all_as_sent
    expect(mail_with_notifications).to_not have_unsent_notifications
  end

  describe ".mail_of" do
    it "return a mail of a specific user mailbox" do
      expect(NotificationMail.mail_of(existing_email)).to be_an(NotificationMail)
    end

    it "creates a new NotificationMail if a new user email is sent" do
      expect(NotificationMail.mail_of(new_email)).to be_an(NotificationMail)
    end

    it "dont create a new NotificationMail when user email is invalid" do
      expect{NotificationMail.mail_of(invalid_email)}.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
