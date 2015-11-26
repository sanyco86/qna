FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@test.com" }
    confirmed_at Time.now
    password '12345678'
    password_confirmation '12345678'
  end
end
