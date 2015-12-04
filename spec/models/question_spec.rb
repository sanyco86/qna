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
  end

  describe '#subscribe_author' do
    it 'adds user to subscribers after create' do
      expect(subject).to receive(:subscribe).with(subject.user)
      subject.save!
    end
  end

  describe '#subscribe' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }

    it 'adds given user to subscribers' do
      expect{
        question.subscribe(user)
      }.to change(question.subscribers, :count).by 1
    end

    it 'doesnt add user to subscribers if he is already there' do
      expect{
        question.subscribe(question.user)
      }.to_not change(question.subscribers, :count)
    end
  end
end

