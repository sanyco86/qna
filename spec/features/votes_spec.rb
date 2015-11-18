require_relative 'feature_helper'

RSpec.feature 'Votes', type: :feature, js: true do
  let(:question) { create(:question) }

  describe 'authenticated user' do
    let(:user) { create(:user) }
    let(:own_question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question) }
    let(:own_answer) { create(:answer, user: user) }

    before do
      sign_in user
    end

    context 'upvotes' do
      before do
        visit question_path(question)
      end

      scenario 'a question' do
        within "#question_#{question.id}" do
          click_on 'Upvote'
          expect(page).to have_selector 'span.upvotes_count', text: 1
          expect(page).to have_selector 'span.votes_count', text: 1
        end
      end

      scenario 'an answer' do
        within "#answer_#{answer.id}" do
          click_on 'Upvote'
          expect(page).to have_selector 'span.upvotes_count', text: 1
          expect(page).to have_selector 'span.votes_count', text: 1
        end
      end
    end

    context 'downvotes' do
      before do
        visit question_path(question)
      end

      scenario 'a question' do
        within "#question_#{question.id}" do
          click_on 'Downvote'
          expect(page).to have_selector 'span.downvotes_count', text: 1
          expect(page).to have_selector 'span.votes_count', text: -1
        end
      end

      scenario 'an answer' do
        within "#answer_#{answer.id}" do
          click_on 'Downvote'
          expect(page).to have_selector 'span.downvotes_count', text: 1
          expect(page).to have_selector 'span.votes_count', text: -1
        end
      end
    end


    context 'unvotes' do
      before do
        user.vote_for(question, :upvote)
        user.vote_for(answer, :upvote)
        visit question_path(question)
      end

      scenario 'a question' do
        within "#question_#{question.id}" do
          click_on 'Unvote'
          expect(page).to have_selector 'span.upvotes_count', text: 0
          expect(page).to have_selector 'span.downvotes_count', text: 0
          expect(page).to have_selector 'span.votes_count', text: 0
        end
      end

      scenario 'an answer' do
        within "#answer_#{answer.id}" do
          click_on 'Unvote'
          expect(page).to have_selector 'span.upvotes_count', text: 0
          expect(page).to have_selector 'span.downvotes_count', text: 0
          expect(page).to have_selector 'span.votes_count', text: 0
        end
      end
    end

    scenario 'cannot vote for his own question' do
      visit question_path(own_question)
      expect(page).to_not have_link 'Upvote'
      expect(page).to_not have_link 'Downvote'
      expect(page).to_not have_link 'Unvote'
    end

    scenario 'cannot vote for his own answer' do
      visit question_path(own_answer.question)
      within '#answers' do
        expect(page).to_not have_link 'Upvote'
        expect(page).to_not have_link 'Downvote'
        expect(page).to_not have_link 'Unvote'
      end
    end
  end

  describe 'not authenticated user' do
    before do
      visit question_path(question)
    end

    scenario 'cannot upvote a question' do
      expect(page).to_not have_link 'Upvote'
    end

    scenario 'cannot downvote a question' do
      expect(page).to_not have_link 'Downvote'
    end

    scenario 'cannot unvote a question' do
      expect(page).to_not have_link 'Unvote'
    end
  end
end
