require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 3) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(3).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'questions object contains short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end

      context 'answers' do
        it 'includes answers list' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do
    let(:access_token) { create(:access_token) }
    let(:question) { create(:question) }
    let!(:comment) { create(:comment, commentable: question) }
    let!(:attachment) { create(:attachment, attachmentable: question) }

    before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

    it 'returns 200 status' do
      expect(response).to be_success
    end

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
        expect(response.body).to have_json_size(1).at_path("question/comments")
      end

      %w(id body created_at updated_at).each do |attr|
        it "comment object contains #{attr}" do
          expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
        end
      end
    end

    context 'attachments' do
      it 'includes attachments list' do
        expect(response.body).to have_json_size(1).at_path("question/attachments")
      end

      it 'attachment object contains url' do
        expect(response.body).to be_json_eql(attachment.url.to_json).at_path("question/attachments/0/url")
      end
    end
  end
end
