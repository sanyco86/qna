require 'rails_helper'

describe User do

  describe 'Associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'Validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe '#vote_for' do
    context 'upvote' do
      it 'increases object upvotes by 1' do
        expect{
          user.vote_for(question, 1)
        }.to change(question.votes.upvotes, :count).by(1)
      end
    end

    context 'downvote' do
      it 'increases object downvotes by 1' do
        expect{
          user.vote_for(question, -1)
        }.to change(question.votes.downvotes, :count).by(1)
      end
    end

    context 'voted before' do
      before do
        user.vote_for(question, 1)
      end

      it 'doesnt change upvote count of object' do
        expect{
          user.vote_for(question, 1)
        }.to_not change(question.votes.upvotes, :count)
      end

      it 'doesnt change downvote count of object' do
        expect{
          user.vote_for(question, -1)
        }.to_not change(question.votes.upvotes, :count)
      end
    end

    context 'own object' do
      let(:own_question) { create(:question, user: user) }

      it 'doesnt change vote count' do
        expect{
          user.vote_for(own_question, 1)
        }.to_not change(question.votes.upvotes, :count)
      end
    end
  end

  describe '#unvote_for' do
    context 'voted before' do
      before do
        user.vote_for(question, 1)
      end

      it 'removes user vote from object' do
        expect{
          user.unvote_for(question)
        }.to change(question.votes, :count).by(-1)
      end
    end

    context 'not voted before' do
      it 'doesnt change vote count for object' do
        expect{
          user.unvote_for(question)
        }.to_not change(question.votes, :count)
      end
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

        it 'does not create new user' do
          expect{
            User.find_for_oauth(auth)
          }.to_not change(User, :count)
        end

        it 'creates new authorization for user' do
          expect{
            User.find_for_oauth(auth)
          }.to change(user.authorizations, :count).by 1
        end

        it 'creates authorization with provider and uid' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'non@existent.com' }) }

        it 'creates new user' do
          expect{
            User.find_for_oauth(auth)
          }.to change(User, :count).by 1
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a User
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).not_to be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  describe '.send_daily_digest' do
    let(:users) { create_list(:user, 2) }
    let!(:questions) { create_list(:question, 2, user: users.first) }
    let(:question_ids) { Question.for_today.pluck(:id) }

    it 'send daily email digest' do
      users.each do |user|
        expect(DailyMailer).to receive(:digest).twice.with(user, question_ids).and_call_original
      end
      User.send_daily_digest
    end
  end
end
