FactoryGirl.define do
  factory :attachment do
    association :attachmentable, factory: :question
    file File.open("#{Rails.root}/spec/spec_helper.rb")
  end
end