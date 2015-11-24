require_relative 'feature_helper'

RSpec.feature 'Comments', type: :feature do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  describe 'authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    context 'question' do
      scenario 'posts comment for question', js: true do
        within '.question_wrapper' do
          fill_in 'comment_body', with: 'dats my comment'
          click_on 'Create Comment'
          expect(page).to have_content "dats my comment by #{user.email}"
        end
      end
    end

    context 'answer' do

      scenario 'posts comment for answer', js: true do
        within "#answer_#{answer.id}" do
          fill_in 'comment_body', with: 'first comment'
          click_on 'Create Comment'
          expect(page).to have_content "first comment by #{user.email}"
          expect(page).to_not have_content "next comment by #{user.email}"

          fill_in 'comment_body', with: 'next comment'
          click_on 'Create Comment'
          expect(page).to have_content "first comment by #{user.email}"
          expect(page).to have_content "next comment by #{user.email}"
        end
      end
    end
  end

  describe 'non authenticated user' do
    scenario 'cannot create comment' do
      visit question_path(question)
      expect(page).to_not have_selector 'form'
    end
  end
end