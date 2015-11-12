require 'rails_helper'

describe AnswersController do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, user: @user) }
  let(:anothers_answer) { create(:answer, question: question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      sign_in_user

      it 'creates new answer' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer)
        }.to change(question.answers, :count).by 1
      end

      it 'correctly assigns user' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(answer.user_id).to eq @user.id
      end

      it 'redirects to question#show' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'with invalid attributes' do
      sign_in_user

      it 'does not create new answer' do
        expect {
          post :create, question_id: question, answer: attributes_for(:invalid_answer)
        }.to_not change(Answer, :count)
      end
    end

    context 'non-authenticated' do
      it 'redirects to root_path' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    before do
      answer
      anothers_answer
    end

    context 'own answer' do
      it 'deletes answer' do
        expect {
          delete :destroy, id: answer, question_id: question
        }.to change(Answer, :count).by(-1)
      end

      it 'redirects to answer question path' do
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to answer.question
      end
    end

    context 'anothers answer' do
      it 'doesnt delete answer' do
        expect {
          delete :destroy, id: anothers_answer, question_id: question
        }.to_not change(Answer, :count)
      end

      it 'redirects to root_path' do
        delete :destroy, id: anothers_answer, question_id: question
        expect(response).to redirect_to root_path
      end
    end
  end
end
