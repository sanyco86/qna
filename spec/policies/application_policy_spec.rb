require_relative '../features/feature_helper'

describe ApplicationPolicy do
  subject { described_class.new('user', 'record') }

  specify { expect(subject.index?).to eq(false) }
  specify { expect(subject.show?).to eq(true) }
  specify { expect(subject.new?).to eq(false) }
  specify { expect(subject.create?).to eq(false) }
  specify { expect(subject.edit?).to eq(false) }
  specify { expect(subject.update?).to eq(false) }
  specify { expect(subject.destroy?).to eq(false) }
end
