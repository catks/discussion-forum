FactoryGirl.define do
  factory :post,aliases:[:comment] do
    title {Faker::Commerce.product_name}
    author {Faker::Internet.email}
    body {Faker::StarWars.quote}

    trait :with_comments do
      after(:create){ |post| 5.times{FactoryGirl.create(:comment,parent_id: post.id)} }
    end

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
