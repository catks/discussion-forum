require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:valid_notification){FactoryGirl.build(:notification)}
  it "can be created with valid attributes" do
    valid_notification.save!
  end

  it "should have a message" do
    notification_without_message = build(:notification, message: "")
    expect{notification_without_message.save!}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should have attached to a notification mail" do
    notification_without_mail = build(:notification, notification_mail_id: nil)
    expect{notification_without_mail.save!}.to raise_error(ActiveRecord::RecordInvalid)
  end

end
