require_relative 'feature_helper'

RSpec.feature 'Attachments', type: :feature do

  describe 'user' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:question_with_attachment) { create(:question, :with_attachment, user: user) }
    let(:answer_with_attachment) { create(:answer, :with_attachment, user: user) }

    before do
      sign_in user
    end

    scenario 'adds files to question', js: true do
      visit new_question_path
      fill_in 'Title', with: 'question title'
      fill_in 'Body', with: 'question body'
      click_on 'Add attachment'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Add attachment'
      all('input[type="file"]')[1].set "#{Rails.root}/spec/rails_helper.rb"

      click_on 'Create'

      expect(page).to have_content 'Question was successfully created.'
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'update files to question', js: true do
      visit edit_question_path(question_with_attachment)

      fill_in 'Title', with: 'updated title'
      fill_in 'Body', with: 'updated body'
      attach_file 'File', "#{Rails.root}/spec/models/answer_spec.rb"
      click_on 'Add attachment'
      all('input[type="file"]')[1].set "#{Rails.root}/spec/models/question_spec.rb"
      click_on 'Create'

      expect(page).to have_content 'Question was successfully updated.'
      expect(page).to have_link 'answer_spec.rb'
      expect(page).to have_link 'question_spec.rb'
      expect(page).to_not have_link 'spec_helper.rb'
      expect(page).to have_content 'updated title'
      expect(page).to have_content 'updated body'
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
    end

    scenario 'removes file from question', js: true do
      visit edit_question_path(question_with_attachment)
      click_on 'Remove this file'
      click_on 'Create'
      expect(page).to have_content 'Question was successfully updated.'
      expect(page).to_not have_link 'spec_helper.rb'
    end

    scenario 'adds files to answer', js: true do
      visit question_path(question)
      fill_in 'Answer', with: 'body'
      click_on 'Add attachment'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Add attachment'
      all('input[type="file"]')[1].set "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Create'

      within '#answers' do
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb'
      end
    end

    scenario 'update files to answer', js: true do
      visit question_path(answer_with_attachment.question)

      within "#answer_#{answer_with_attachment.id}" do
        click_on 'Edit'
        fill_in 'Answer', with: 'updated'
        attach_file 'File', "#{Rails.root}/spec/models/answer_spec.rb"
        click_on 'Save'

        expect(page).to have_link 'answer_spec.rb'
        expect(page).to_not have_link 'spec_helper.rb'
        expect(page).to have_content 'updated'
        expect(page).to_not have_content answer_with_attachment.body
      end
    end

    scenario 'removes file from answer', js: true do
      visit question_path(answer_with_attachment.question)

      within "#answer_#{answer_with_attachment.id}" do
        click_on 'Edit'
        click_on 'Remove this file'
        click_on 'Save'
        expect(page).to_not have_link 'spec_helper.rb'
      end
    end
  end
end