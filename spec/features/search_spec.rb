require_relative 'feature_helper'

RSpec.feature 'Search', type: :feature do
  describe 'user searches' do
    let!(:question) { create(:question, title: 'without') }
    let!(:answer) { create(:answer, body: 'conditions') }

    before do
      visit root_path
    end

    context 'with conditions' do
      it 'returns given question', js: true do
        ThinkingSphinx::Test.run do
          fill_in 'Search', with: 'conditions'
          select 'answers', from: 'search_conditions'
          click_on 'Go!'
          expect(page).to have_content 'Search results:'
          expect(page).to_not have_link question.title
          expect(page).to have_link answer.question.title
        end
      end
    end

    context 'without conditions' do
      it 'returns given question', js: true do
        ThinkingSphinx::Test.run do
          fill_in 'Search', with: 'without'
          click_on 'Go!'
          expect(page).to have_content 'Search results:'
          expect(page).to have_link question.title
          expect(page).to_not have_link answer.question.title
        end
      end
    end
  end
end
