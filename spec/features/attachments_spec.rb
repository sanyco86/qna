require_relative 'feature_helper'

RSpec.feature 'Attachments', type: :feature do

  describe 'user' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    before do
      sign_in user
    end

    scenario 'adds file to question' do
      visit new_question_path
      fill_in 'Title', with: 'question title'
      fill_in 'Body', with: 'question body'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

      click_on 'Create'

      expect(page).to have_link 'spec_helper.rb', href: "/uploads/attachment/file/#{Attachment.last.id}/spec_helper.rb"
    end

    scenario 'adds file to answer', js: true do
      visit question_path(question)
      fill_in 'Answer', with: 'body'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

      click_on 'Create'

      within '#answers' do
        expect(page).to have_link 'spec_helper.rb', href: "/uploads/attachment/file/#{Attachment.last.id}/spec_helper.rb"
      end
    end
  end
end