FactoryGirl.define do
  factory :notification do
    message {Faker::ChuckNorris.fact}
    sent false
    notification_mail_id {FactoryGirl.create(:notification_mail).id}
  end
end
