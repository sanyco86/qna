require_relative 'feature_helper'

RSpec.feature 'Questions', type: :feature do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, user: user, title: 'Question') }

  describe 'authenticated user' do
    let(:question_params) { build(:question, title: 'MyString', body: 'MyText') }

    before do
      sign_in user
    end

    scenario 'can create question' do
      click_on 'Ask question'

      fill_in 'Title', with: question_params.title
      fill_in 'Body', with: question_params.body

      click_on 'Create'

      expect(page).to have_content 'Question was successfully created.'
      expect(page).to have_content question_params.title
      expect(page).to have_content question_params.body
    end

    scenario 'can edit his question from show page' do
      visit edit_question_path(question)

      fill_in 'Title', with: 'updated title'
      fill_in 'Body', with: 'updated body'
      click_on 'Create'

      expect(page).to have_content 'Question was successfully updated.'
      expect(page).to have_content 'updated title'
      expect(page).to have_content 'updated body'
      expect(page).to_not have_content question_params.title
      expect(page).to_not have_content question_params.body
    end
  end

  describe 'non-authenticated user' do
    scenario 'cannot create question' do
      visit new_question_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  describe 'any user' do
    scenario 'can view list of questions' do
      question_list = create_list(:question, 3)

      visit questions_path

      question_list.each { |question| expect(page).to have_content question.title }
    end

    scenario 'cannot delete anothers question' do
      sign_in another_user

      visit question_path(question)
      expect(page).to_not have_link 'Edit'
    end

    scenario "cannot delete another's question" do
      sign_in another_user

      visit question_path(question)
      expect(page).to_not have_link 'Destroy'
    end
  end
end
