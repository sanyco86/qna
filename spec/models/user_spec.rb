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
end