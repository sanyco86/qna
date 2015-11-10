require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user create the question' do

    sign_in(user)

    visit questions_path
    click_on 'Задать вопрос'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_on 'Создать'

    expect(page).to have_content 'Ваш вопрос успешно создан.'
  end

  scenario 'Non-authenticated user try to create question' do
    visit questions_path
    click_on 'Задать вопрос'

    expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться.'
  end
end
