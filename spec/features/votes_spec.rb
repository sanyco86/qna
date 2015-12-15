require_relative 'feature_helper'

RSpec.feature 'Votes', type: :feature, js: true do
  let(:question) { create(:question) }

  describe 'voted multiple users' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:answer) { create(:answer, question: question) }
    let(:vote_answer) { create(:vote, votable: answer, user: user) }
    let(:vote_question) { create(:vote, votable: question, user: user) }

    before do
      sign_in user2
    end

    context 'upvotes' do
      scenario 'a question' do
        visit question_path(vote_question.votable)
        within "#question_#{question.id}" do
          click_on 'Upvote'
          expect(page).to have_selector 'span.upvotes_count', text: 2
          expect(page).to have_selector 'span.votes_count', text: 2
        end
      end

      scenario 'an answer' do
        visit question_path(vote_answer.votable.question)
        within "#answer_#{answer.id}" do
          click_on 'Upvote'
          expect(page).to have_selector 'span.upvotes_count', text: 2
          expect(page).to have_selector 'span.votes_count', text: 2
        end
      end
    end
  end

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
          expect(page).to_not have_link 'Upvote'
          expect(page).to_not have_link 'Downvote'
          expect(page).to have_link 'Unvote'
        end
      end

      scenario 'an answer' do
        within "#answer_#{answer.id}" do
          click_on 'Upvote'
          expect(page).to have_selector 'span.upvotes_count', text: 1
          expect(page).to have_selector 'span.votes_count', text: 1
          expect(page).to_not have_link 'Upvote'
          expect(page).to_not have_link 'Downvote'
          expect(page).to have_link 'Unvote'
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
          expect(page).to_not have_link 'Upvote'
          expect(page).to_not have_link 'Downvote'
          expect(page).to have_link 'Unvote'
        end
      end

      scenario 'an answer' do
        within "#answer_#{answer.id}" do
          click_on 'Downvote'
          expect(page).to have_selector 'span.downvotes_count', text: 1
          expect(page).to have_selector 'span.votes_count', text: -1
          expect(page).to_not have_link 'Upvote'
          expect(page).to_not have_link 'Downvote'
          expect(page).to have_link 'Unvote'
        end
      end
    end


    context 'unvotes' do
      before do
        visit question_path(question)
      end

      scenario 'a question' do
        within "#question_#{question.id}" do
          click_on 'Upvote'
          expect(page).to have_selector 'span.upvotes_count', text: 1
          expect(page).to_not have_link 'Upvote'
          expect(page).to_not have_link 'Downvote'
          click_on 'Unvote'
          expect(page).to have_selector 'span.upvotes_count', text: 0
          expect(page).to have_selector 'span.downvotes_count', text: 0
          expect(page).to have_selector 'span.votes_count', text: 0
          expect(page).to have_link 'Upvote'
          expect(page).to have_link 'Downvote'
          expect(page).to_not have_link 'Unvote'
        end
      end

      scenario 'an answer' do
        within "#answer_#{answer.id}" do
          click_on 'Upvote'
          expect(page).to have_selector 'span.upvotes_count', text: 1
          expect(page).to_not have_link 'Upvote'
          expect(page).to_not have_link 'Downvote'
          click_on 'Unvote'
          expect(page).to have_selector 'span.upvotes_count', text: 0
          expect(page).to have_selector 'span.downvotes_count', text: 0
          expect(page).to have_selector 'span.votes_count', text: 0
          expect(page).to have_link 'Upvote'
          expect(page).to have_link 'Downvote'
          expect(page).to_not have_link 'Unvote'
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
