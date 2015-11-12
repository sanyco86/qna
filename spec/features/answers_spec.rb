require 'rails_helper'

RSpec.feature 'Answers', type: :feature do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer_params) { build(:answer, body: 'Random text') }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'authenticated user' do
    before do
      sign_in(user)
    end

    scenario 'creates an answer', js: true do
      visit question_path(question)

      fill_in 'Answer', with: answer_params.body
      click_on 'Create'

      expect(page).to have_content answer_params.body
    end

    scenario 'deletes an answer' do
      visit question_path(question)

      click_on 'Destroy'

      expect(page).to have_content 'Answer was successfully destroyed'
      expect(page).to_not have_content answer.body
    end
  end

  describe 'any user' do
    scenario 'cannot delete anothers answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Destroy'
    end
  end

  describe 'non-authenticated user' do
    scenario 'cannot create an answer' do
      visit question_path(question)

      expect(page).to_not have_content 'New answer'
    end

    scenario 'can see answer list' do
      answer_list = create_list(:answer, 3, question: question)

      visit question_path(question)

      answer_list.each { |answer| expect(page).to have_content answer.body }
    end
  end
end
