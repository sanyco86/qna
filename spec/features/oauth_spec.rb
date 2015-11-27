require_relative 'feature_helper'

RSpec.feature 'OAuth', type: :feature do
  let!(:user) { create(:user) }
  let(:question_params) { build(:question, title: 'MyString', body: 'MyText') }

  before do
    OmniAuth.config.test_mode = true
    visit root_path
  end

  describe 'vkontakte' do
    before do
      click_on 'Sign in'
      mock_auth_hash(:vkontakte)
    end

    describe 'update email' do
      let(:user) { create :user, email: 'change-email@email.com' }
      before { click_on 'Sign in with Vkontakte' }

      scenario 'successfuly' do
        fill_in 'auth_info_email', with: 'test@test.com'
        click_on 'Submit'
        expect(page).to have_content 'Successfully authenticated from Vkontakte account'

        click_on 'Sign out'
        click_on 'Sign in'
        click_on 'Sign in with Vkontakte'

        click_on 'Ask question'
        fill_in 'Title', with: question_params.title
        fill_in 'Body', with: question_params.body

        click_on 'Create'

        expect(page).to have_content 'Question was successfully created.'
        expect(page).to have_content question_params.title
        expect(page).to have_content question_params.body
      end

      scenario 'when it has not been updated' do
        click_on 'Submit'
        expect(page).to have_content 'Email is required to compete sign up'
      end
    end


    scenario 'with invalid credentials' do
      OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
      click_on 'Sign in with Vkontakte'
      expect(page).to have_content 'Could not authenticate you from Vkontakte because "Invalid credentials"'
    end
  end

  describe 'facebook Sign in' do

    it 'successfully' do
      mock_auth_hash(:facebook)
      click_on 'Sign in'
      click_on 'Sign in with Facebook'
      expect(page).to have_content 'Successfully authenticated from Facebook account.'

      click_on 'Ask question'
      fill_in 'Title', with: question_params.title
      fill_in 'Body', with: question_params.body

      click_on 'Create'

      expect(page).to have_content 'Question was successfully created.'
      expect(page).to have_content question_params.title
      expect(page).to have_content question_params.body
    end

    it 'with invalid credentials' do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      click_link 'Sign in'
      click_on 'Sign in with Facebook'
      expect(page).to have_content 'Could not authenticate you from Facebook because "Invalid credentials"'
    end
  end
end
