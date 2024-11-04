FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { "12345678" }
    password_confirmation { '12345678' }
    username { Faker::Internet.unique.username }
    confirmed_at { Time.current }
  end
end
