require 'rails_helper'

feature 'User sign up', %q{
  In order to be able to ask question
  As an authenticated user
  I want to be able to sign up
 } do

  scenario 'Guest entered valid data' do
    visit new_user_registration_path

    fill_in 'Email', with: 'newuser@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    expect { click_button 'Sign up' }.to change(User, :count).by 1
    expect(page).to have_content 'successfully'
  end

  scenario 'Guest entered invalid data' do
    visit new_user_registration_path

    fill_in 'Email', with: 'newuser@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: nil
    click_button 'Sign up'

    expect(page).to have_content('error')
  end

end