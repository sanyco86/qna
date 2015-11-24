FactoryGirl.define do
  factory :comment do
    body 'MyString'
    user

    trait :with_wrong_attributes do
      body nil
    end
  end
end