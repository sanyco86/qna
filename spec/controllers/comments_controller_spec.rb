require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:comment) { build(:comment) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'GET #create' do
    context 'authenticated user' do
      sign_in_user

      it 'creates new comment for a question' do
        expect {
          post :create, comment: attributes_for(:comment), question_id: question, format: :json
        }.to change(question.comments, :count).by 1
      end

      it 'creates new comment for an answer' do
        expect {
          post :create, comment: attributes_for(:comment), answer_id: answer, format: :json
        }.to change(answer.comments, :count).by 1
      end

      it 'creates new comment for a user' do
        expect {
          post :create, comment: attributes_for(:comment), question_id: question, format: :json
        }.to change(@user.comments, :count).by 1
      end
    end

    context 'non-authenticated user' do
      it 'cannot create comment' do
        expect {
          post :create, comment: attributes_for(:comment), question_id: question, format: :json
        }.to_not change(Comment, :count)
      end
    end
  end
end