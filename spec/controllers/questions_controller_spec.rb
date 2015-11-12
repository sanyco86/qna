require 'rails_helper'

describe QuestionsController do
  let(:question) { create(:question, user: @user) }
  let(:anothers_question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'returns array of all questions' do
      expect(assigns(:questions)).to match_array questions
    end

    it 'renders questions#index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders questions#show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders questions#new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user

    before { get :edit, id: question }

    it 'assigns requsted question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders questions#edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'creates a new question' do
        expect {
          post :create, question: attributes_for(:question)
        }.to change(@user.questions, :count).by 1
      end

      it 'redirects to question#show' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'doesnt create a new question' do
        expect {
          post :create, question: attributes_for(:invalid_question)
        }.to_not change(Question, :count)
      end

      it 'renders questions#new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'with valid attributes' do
      before { patch :update, id: question, question: { title: 'new title', body: 'new body' } }

      it 'assigns requsted question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'updates question attributes' do
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updates question' do
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      before { patch :update, id: question, question: { title: 'new title', body: nil} }

      it 'does not update question attributes' do
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 'renders questions#edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    before do
      question
      anothers_question
    end

    context 'own question' do

      it 'deletes question' do
        expect {
          delete :destroy, id: question
        }.to change(Question, :count).by(-1)
      end

      it 'redirects to questions#index' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context 'anothers question' do
      it 'doesnt delete question' do
        expect {
          delete :destroy, id: anothers_question
        }.to_not change(Question, :count)
      end

      it 'redirects to questions#index' do
        delete :destroy, id: anothers_question
        expect(response).to redirect_to root_path
      end
    end
  end
end