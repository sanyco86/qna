require_relative 'feature_helper'

RSpec.feature 'Attachments', type: :feature do

  describe 'user' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:question_with_attachment) { create(:question, :with_attachment) }
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
      expect(page).to have_link 'spec_helper.rb', href: "/uploads/attachment/file/#{Attachment.last(2).first.id}/spec_helper.rb"
      expect(page).to have_link 'rails_helper.rb', href: "/uploads/attachment/file/#{Attachment.last(2).last.id}/rails_helper.rb"
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
        expect(page).to have_link 'spec_helper.rb', href: "/uploads/attachment/file/#{Attachment.last(2).first.id}/spec_helper.rb"
        expect(page).to have_link 'rails_helper.rb', href: "/uploads/attachment/file/#{Attachment.last(2).last.id}/rails_helper.rb"
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