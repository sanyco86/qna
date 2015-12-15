require 'rails_helper'

describe Question do
  subject { build(:question) }

  describe 'Associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to :user }
    it { should have_many(:attachments).dependent(:destroy) }
    it { should accept_nested_attributes_for :attachments }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'Validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_presence_of :user_id }
  end

  describe '#subscribe_author' do
    it 'adds user to subscribers after create' do
      expect(subject).to receive(:subscribe).with(subject.user)
      subject.save!
    end
  end

  describe '#subscribe' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    it 'adds given user to subscribers' do
      expect do
        question.subscribe(user)
      end.to change(question.subscribers, :count).by 1
    end

    it 'doesnt add user to subscribers if he is already there' do
      expect do
        question.subscribe(question.user)
      end.to_not change(question.subscribers, :count)
    end
  end

  describe '#unsubscribe' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    it 'adds given user to subscribers' do
      expect do
        question.unsubscribe(question.user)
      end.to change(question.subscribers, :count).by(-1)
    end

    it 'doesnt add user to subscribers if he is already there' do
      expect do
        question.unsubscribe(user)
      end.to_not change(question.subscribers, :count)
    end
  end
end
