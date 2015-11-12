FactoryGirl.define do
  factory :answer do
    body 'Answer body'
    question
    user

    trait :invalid do
      body nil
    end
  end
end