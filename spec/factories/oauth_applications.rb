FactoryGirl.define do
  factory :oauth_application, class: Doorkeeper::Application do
    name 'Test'
    redirect_uri 'urn:ietf:wg:oauth:2.0:oob'
    sequence(:uid) { |n| "1234567#{n}" }
    secret '87654321'
  end
end
