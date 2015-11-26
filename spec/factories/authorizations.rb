FactoryGirl.define do
  factory :authorization do
    user nil
    provider 'MyString'
    uid 1
  end
end