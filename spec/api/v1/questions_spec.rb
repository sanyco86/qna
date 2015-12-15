require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like 'Api Authenticable'

    context 'authorized', :lurker do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 3) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it_behaves_like 'successfully reponsible'

      it 'returns list of questions' do
        expect(response.body).to have_json_size(3).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'questions object contains short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('questions/0/short_title')
      end

      context 'answers' do
        it 'includes answers list' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(
              answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}"
                                                       )
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let(:access_token) { create(:access_token) }
    let(:question) { create(:question) }
    let!(:comment) { create(:comment, commentable: question) }
    let!(:attachment) { create(:attachment, attachmentable: question) }

    it_behaves_like 'Api Authenticable'

    context 'authorized', :lurker do
      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it_behaves_like 'successfully reponsible'

      it 'returns question object' do
        expect(response.body).to have_json_size(1)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'comments' do
        it 'includes comments list' do
          expect(response.body).to have_json_size(1).at_path('question/comments')
        end

        %w(id body created_at updated_at).each do |attr|
          it "comment object contains #{attr}" do
            expect(response.body).to be_json_eql(
              comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}"
                                                        )
          end
        end
      end

      context 'attachments' do
        it 'includes attachments list' do
          expect(response.body).to have_json_size(1).at_path('question/attachments')
        end

        it 'attachment object contains url' do
          expect(response.body).to be_json_eql(attachment.url.to_json).at_path('question/attachments/0/url')
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    let(:access_token) { create(:access_token) }
    let(:user) { User.find(access_token.resource_owner_id) }

    it_behaves_like 'Api Authenticable'

    context 'authorized' do
      context 'with valid attributes', :lurker do
        subject do
          post '/api/v1/questions', format: :json, access_token: access_token.token, question: attributes_for(:question)
        end

        it 'reponses with 201' do
          subject
          expect(response.status).to eq 201
        end

        it 'creates new question' do
          expect do
            subject
          end.to change(user.questions, :count).by 1
        end
      end

      context 'with invalid attributes' do
        subject { post '/api/v1/questions', format: :json, access_token: access_token.token, question: { body: nil } }

        it 'responses with 422' do
          subject
          expect(response.status).to eq 422
        end

        it 'doesnt create new question' do
          expect do
            subject
          end.to_not change(Question, :count)
        end
      end
    end

    def do_request(options = {})
      post '/api/v1/questions', { format: :json }.merge(options)
    end
  end
end
