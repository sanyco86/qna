require_relative 'feature_helper'

RSpec.feature 'Users', type: :feature do
  given(:user) { create(:user) }
  let(:n_user) { build(:user) }

  scenario 'registered user can sign in' do
    sign_in(user)
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'signed in user can sign out' do
    sign_in(user)
    click_on 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'unregistered user cannot sign in' do
    sign_in n_user
    expect(page).to have_content 'Invalid email or password.'
  end

  scenario 'guest can register' do
    visit root_path
    click_on 'Sign up'

    fill_in 'Email', with: n_user.email
    fill_in 'Password', with: n_user.password
    fill_in 'Password confirmation', with: n_user.password
    click_button 'Sign up'

    expect(page).to have_content 'You have signed up successfully.'
  end
end
