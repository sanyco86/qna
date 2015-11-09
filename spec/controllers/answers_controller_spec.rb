require 'rails_helper'

describe AnswersController do
  describe 'POST #create' do
    let(:question) { create(:question) }
    let(:answer) { build(:answer, question: question) }

    context 'with valid attributes' do
      it 'creates new answer' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer)
        }.to change(question.answers, :count).by 1
      end

      it 'redirects to question#show' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to answer.question
      end
    end

    context 'with invalid attributes' do
      it 'does not create new answer' do
        expect {
          post :create, question_id: question, answer: attributes_for(:invalid_answer)
        }.to_not change(Answer, :count)
      end
    end
  end
end
