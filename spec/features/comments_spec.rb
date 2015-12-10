require_relative 'feature_helper'

RSpec.feature 'Comments', type: :feature do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let(:comment_params) { build(:comment, body: 'Random text') }

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
      scenario 'can view list of comments', js: true do
        comment_list = create_list(:comment, 2, commentable: question)
        visit question_path(question)
        within '.question_wrapper' do
          comment_list.each { |comment| expect(page).to have_content comment.body }
        end
      end
    end

    context 'answer' do
      scenario 'posts comment for answer', js: true do
        within "#answer_#{answer.id}" do
          fill_in 'comment_body', with: comment_params.body
          click_on 'Create Comment'

          expect(page).to have_content comment_params.body
        end
      end

      scenario 'can view list of comments', js: true do
        comment_list = create_list(:comment, 2, commentable: answer)
        visit question_path(question)
        within "#answer_#{answer.id}" do
          comment_list.each { |comment| expect(page).to have_content comment.body }
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