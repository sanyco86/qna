require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create :user }
  let(:author) { create :user }
  let!(:question) { create :question, user: author }
  let!(:answer) { create :answer, question: question, user: author }

  describe 'POST#create' do
    describe 'Question comment' do
      let(:create_params) {{ comment: attributes_for(:comment),
                             commentable: 'questions',
                             question_id: question,
                             format: :json }}

      describe 'Authenticated user' do
        let(:subject) { post :create, create_params }
        let(:publish_url) { "/questions/#{question.id}/comments" }

        before { sign_in(user) }

        context 'when valid attributes' do
          it 'saves a new answer to the database' do
            expect{ subject }
                .to change(question.comments, :count).by(1)
          end

          it 'author question comment' do
            expect {
              subject
            }.to change(user.comments, :count).by 1
          end

          it 'renders show template' do
            subject
            expect(response).to render_template 'comments/show'
          end

          it_behaves_like 'publishable'
        end

        context 'when invalid attributes' do
          let(:wrong_params){{ comment: attributes_for(:comment, :with_wrong_attributes),
                               commentable: 'questions',
                               question_id: question,
                               format: :json }}

          it 'does not save a new answer to the database' do
            expect { post :create, wrong_params }
                .not_to change(Comment, :count)
          end

          it 'renders unprocessable entity' do
            post :create, wrong_params
            expect(response.status).to eq 422
          end
        end
      end

      describe 'Unauthenticated user' do
        it 'can not comment' do
          expect{ post :create, create_params}
              .not_to change(Comment, :count)
        end
      end
    end

    describe 'Answer comment' do
      let(:create_params) {{ comment: attributes_for(:comment),
                             commentable: 'answers',
                             answer_id: answer,
                             format: :json }}

      describe 'Authenticated user' do
        before { sign_in(user) }

        context 'when valid attributes' do
          it 'saves a new answer to the database' do
            expect{ post :create, create_params }
                .to change(answer.comments, :count).by(1)
          end

          it 'renders show template' do
            post :create, create_params
            expect(response).to render_template 'comments/show'
          end
        end

        context 'when invalid attributes' do
          let(:wrong_params){{ comment: attributes_for(:comment, :with_wrong_attributes),
                               commentable: 'answers',
                               answer_id: answer,
                               user_id: author,
                               format: :json }}

          it 'does not save a new answer to the database' do
            expect { post :create, wrong_params }
                .not_to change(Comment, :count)
          end

          it 'renders unprocessable entity' do
            post :create, wrong_params
            expect(response.status).to eq 422
          end
        end
      end

      describe 'Unauthenticated user' do
        it 'can not comment' do
          expect{ post :create, create_params}
              .not_to change(Comment, :count)
        end
      end
    end
  end
end