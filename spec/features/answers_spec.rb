require_relative 'feature_helper'

RSpec.feature 'Answers', type: :feature do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer_params) { build(:answer, body: 'Random text') }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'creates an answer', js: true do
      fill_in 'Answer', with: answer_params.body
      click_on 'Create'

      expect(page).to have_content answer_params.body
    end

    scenario 'deletes an answer', js: true do
      within "#answer_#{answer.id}" do
        click_on 'Destroy'
      end

      expect(page).to_not have_content answer.body
    end

    scenario 'sees Edit link' do
      within "#answer_#{answer.id}" do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'can edit his answer', js: true do
      within "#answer_#{answer.id}" do
        click_on 'Edit'
        fill_in 'Answer', with: 'updated'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'updated'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'choose best answer', js: true do
      within "#answer_#{answer.id}" do
        click_on 'Best answer'
        expect(page).to have_content 'best answer'
      end
    end
  end

  describe 'any user' do
    before do
      sign_in another_user
      visit question_path(question)
    end

    scenario 'cannot edit not his answer' do
      within "#answer_#{answer.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario "cannot delete another's answer" do
      within "#answer_#{answer.id}" do
        expect(page).to_not have_link 'Destroy'
      end
    end

    scenario 'cannot chose best answer for anothers question' do
      expect(page).to_not have_link 'Best answer'
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

      answer_list.each do |answer|
        expect(page).to have_content answer.body
      end
    end
  end
end