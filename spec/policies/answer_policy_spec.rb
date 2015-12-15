require_relative '../features/feature_helper'

describe AnswerPolicy do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }

  subject { described_class }

  [:update?, :destroy?].each do |method|
    permissions method do
      it 'grants access if user is an author' do
        expect(subject).to permit(user, answer)
      end

      it 'denies access if user is not an author' do
        expect(subject).to_not permit(User.new, answer)
      end
    end
  end

  permissions :make_best? do
    it 'grants access if user is a question author' do
      expect(subject).to permit(user, answer)
    end

    it 'denies access if user is not an author' do
      expect(subject).to_not permit(User.new, answer)
    end
  end
end
