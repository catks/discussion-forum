FactoryGirl.define do
  factory :post do
    title {Faker::Commerce.product_name}
    author {Faker::Internet.email}
    body {Faker::StarWars.quote}
  end

  factory :censored_post, parent: :post do
    body "badword"
  end

  factory :invalid_post, parent: :post do
    title nil
    author nil
    body nil
  end
end
