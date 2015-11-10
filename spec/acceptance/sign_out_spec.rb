require 'rails_helper'

feature 'User sign out', %q{
  In order to close session.
 } do

  given(:user) { create(:user) }

  scenario 'signed in user can sign out' do
    sign_in(user)
    click_on 'Sign out'
    expect(page).to have_content 'successfully'
  end
end