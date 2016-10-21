FactoryGirl.define do
  factory :notification_mail do
    user {Faker::Internet.email}

    trait :with_notifications do
      after(:create) { |nmail| 4.times{FactoryGirl.create(:notification,notification_mail_id: nmail.id)}}
    end
  end

end
