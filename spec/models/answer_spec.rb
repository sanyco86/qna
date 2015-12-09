require 'rails_helper'

describe Answer do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let!(:answers) { create_list(:answer, 5, question: question, best: true) }

  describe 'Associations' do
    it { should belong_to :question }
    it { should belong_to :user }
    it { should have_many(:attachments).dependent(:destroy) }
    it { should accept_nested_attributes_for :attachments }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'Validations' do
    it { should validate_presence_of :body }
    it { should validate_presence_of :question_id }
  end

  describe 'default_scope' do
    let!(:best_answer) { create(:answer, question: question) }

    it 'shows best answer first' do
      best_answer.make_best
      question.answers.reload
      expect(question.answers.first).to eq best_answer
    end
  end

  describe '#make_best' do
    it 'sets #best to true' do
      answer.make_best
      answer.reload
      expect(answer).to be_best
    end

    it 'sets #best to all other answers to false' do
      answer.make_best
      answers.each do |ans|
        ans.reload
        expect(ans).to_not be_best
      end
    end
  end

  describe '#report_to_subscribers', :focus do
    let(:q2a) { Answer.for_notification.group_by(&:question_id) }
    let(:qsn) {Question.where(id: q2a.keys).includes(:subscribers)}

    it 'send email to question subscribers' do
      qsn.find_each do |q|
        q.subscribers.find_each do |user|
          expect(SubscriptionMailer).to receive(:report).twice.with(user, q, q2a[q.id]).and_call_original
        end
      end
      Answer.notify_new_answers
    end
  end
end

