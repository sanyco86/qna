require_relative '../features/feature_helper'

describe QuestionPolicy do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  subject { described_class }

  [:update?, :edit?, :destroy?].each do |method|
    permissions method do
      it 'grants access if user is an author' do
        expect(subject).to permit(user, question)
      end

      it 'denies access if user is not an author' do
        expect(subject).to_not permit(User.new, question)
      end
    end
  end
end
