require_relative 'feature_helper'

RSpec.feature 'OAuth', type: :feature do
  let!(:user) { create(:user) }

  before do
    OmniAuth.config.test_mode = true
    visit new_user_session_path
  end

  describe 'twitter' do
    before do
      OmniAuth.config.mock_auth[:twitter] = nil
      click_on 'Sign in with Twitter'
      mock_auth_hash(:twitter)
    end

    scenario 'user signs in from twitter' do
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      fill_in 'Email', with: 'correct@email.com'
      click_on 'Continue'
      expect(page).to have_content 'Your email was updated. We have sent you a confirmation email.'
    end

    scenario 'user signs in from twitter and doesnt fill email' do
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      click_on 'Continue'
      expect(page).to have_content 'Please confirm your email address.'
    end

    scenario 'user signs in from twitter and uses taken email' do
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      fill_in 'Email', with: user.email
      click_on 'Continue'
      expect(page).to have_content 'Email has already been taken'
    end
  end

  describe 'facebook' do
    scenario 'user signs in from facebook' do
      click_on 'Sign in with Facebook'
      mock_auth_hash(:facebook)
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end
  end
end