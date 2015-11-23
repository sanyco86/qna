FactoryGirl.define do
  factory :comment do
    association :commentable, factory: :question
    body 'MyString'
    user
  end
end