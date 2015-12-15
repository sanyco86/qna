require 'rails_helper'

describe QuestionsController do
  let(:user) { create :user }
  let(:question) { create(:question, user: user) }
  let(:anothers_question) { create(:question) }

  describe 'GET #index' do
    let!(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'returns array of all questions' do
      expect(assigns(:questions)).to match_array Question.all
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
    before do
      sign_in(user)
      get :new
    end

    it 'assigns new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders questions#new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before do
      sign_in(user)
      get :edit, id: question
    end

    it 'assigns requsted question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders questions#edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    let(:subject) { post :create, question: attributes_for(:question) }
    let(:publish_url) { '/questions' }
    before { sign_in(user) }

    context 'with valid attributes' do
      it 'creates a new question' do
        expect do
          subject
        end.to change(user.questions, :count).by 1
      end

      it 'redirects to question#show' do
        subject
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it_behaves_like 'publishable', '/questions'
    end

    context 'with invalid attributes' do
      it 'doesnt create a new question' do
        expect do
          post :create, question: attributes_for(:question, :invalid)
        end.to_not change(Question, :count)
      end

      it 'renders questions#new view' do
        post :create, question: attributes_for(:question, :invalid)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before do
        sign_in(user)
        patch :update, id: question, question: { title: 'new title', body: 'new body' }
      end

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
      before do
        sign_in(user)
        patch :update, id: question, question: { title: 'new title', body: nil }
      end

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
    before do
      sign_in(user)
      question
      anothers_question
    end

    context 'own question' do
      it 'deletes question' do
        expect do
          delete :destroy, id: question
        end.to change(Question, :count).by(-1)
      end

      it 'redirects to questions#index' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context 'anothers question' do
      it 'doesnt delete question' do
        expect do
          delete :destroy, id: anothers_question
        end.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH #upvote' do
    before { sign_in(user) }

    it 'renders question/vote.json.jbuilder' do
      patch :upvote, id: question, format: :json
      expect(response).to render_template :vote
    end

    it 'save/delete upvote' do
      expect do
        patch :upvote, id: question, format: :json
      end.to change(question.votes.upvotes, :count).by 1
      expect do
        patch :unvote, id: question, format: :json
      end.to change(question.votes.upvotes, :count).by(-1)
    end
  end

  describe 'PATCH #downvote' do
    before { sign_in(user) }

    it 'renders question/vote.json.jbuilder' do
      patch :downvote, id: question, format: :json
      expect(response).to render_template :vote
    end

    it 'save/delete  downvote' do
      expect do
        patch :downvote, id: question, format: :json
      end.to change(question.votes.downvotes, :count).by 1
      expect do
        patch :unvote, id: question, format: :json
      end.to change(question.votes.downvotes, :count).by(-1)
    end
  end

  describe 'PATCH #unvote' do
    before { sign_in(user) }

    it 'renders question/vote.json.jbuilder' do
      patch :unvote, id: question, format: :json
      expect(response).to render_template :vote
    end
  end
end
