FactoryGirl.define do
  factory :answer do
    body 'Answer body'
    question
    user

    trait :invalid do
      body nil
    end

    trait :with_attachment do
      after(:create) do |question|
        question.attachments << create(:attachment)
      end
    end
  end
end
