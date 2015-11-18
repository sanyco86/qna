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
          post :create, question_id: question, answer: attributes_for(:answer), format: :json
        }.to change(question.answers, :count).by 1
      end

      it 'correctly assigns user' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer), format: :json
        }.to change(@user.answers, :count).by 1
      end

      it 'renders show template' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :json
        expect(response).to render_template :show
      end
    end

    context 'with invalid attributes' do
      sign_in_user

      it 'does not create new answer' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer, :invalid), format: :json
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

  describe 'PATCH #update' do
    sign_in_user

    it 'assigns requested answer to @answer' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :json
      expect(assigns(:answer)).to eq answer
    end

    it 'changes answer attributes' do
      patch :update, id: answer, question_id: question, answer: { body: 'updated' }, format: :json
      answer.reload
      expect(answer.body).to eq 'updated'
    end

    it 'renders show template' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :json
      expect(response).to render_template :show
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
          delete :destroy, id: answer, question_id: question, format: :js
        }.to change(Answer, :count).by(-1)
      end

      it 'redirects to answer question path' do
        delete :destroy, id: answer, question_id: question, format: :js
        expect(response).to render_template :destroy
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

  describe 'PATCH #make_best' do
    context 'correct user' do
      sign_in_user

      before do
        question.update(user: @user)
        patch :make_best, id: answer, question_id: question, format: :js
      end

      it 'sets #best to true' do
        answer.reload
        expect(answer).to be_best
      end

      it 'renders #make_best template' do
        expect(response).to render_template :make_best
      end
    end

    context 'incorrect user' do
      sign_in_user

      it 'doesnt change #best' do
        expect{
          patch :make_best, id: answer, question_id: question, format: :js
          answer.reload
        }.to_not change(answer, :best)
      end
    end
  end

  describe 'PATCH #upvote' do
    sign_in_user

    it 'renders answer/vote.json.jbuilder' do
      patch :upvote, id: answer, format: :json
      expect(response).to render_template :vote
    end
  end

  describe 'PATCH #downvote' do
    sign_in_user

    it 'renders answer/vote.json.jbuilder' do
      patch :downvote, id: answer, format: :json
      expect(response).to render_template :vote
    end
  end

  describe 'PATCH #unvote' do
    sign_in_user

    it 'renders answer/vote' do
      patch :unvote, id: answer, format: :json
      expect(response).to render_template :vote
    end
  end
end
