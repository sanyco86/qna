FactoryGirl.define do
  factory :question do
    title 'MyString'
    body 'MyText'
    user

    trait :invalid do
      title nil
      body nil
    end

    trait :with_attachment do
      after(:create) do |question|
        question.attachments << create(:attachment)
      end
    end
  end
end