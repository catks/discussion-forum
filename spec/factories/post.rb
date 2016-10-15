FactoryGirl.define do
  factory :post do
    title {Faker::Commerce.product_name}
    author {Faker::Internet.email}
    body {Faker::StarWars.quote}
  end

  factory :censored_post, parent: :post do
    body "badword"
  end
end
