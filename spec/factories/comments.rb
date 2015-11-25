FactoryGirl.define do
  factory :comment do
    sequence(:body) { |n| "Comment_#{n}" }
    user

    trait :with_wrong_attributes do
      body nil
    end
  end
end