require 'rails_helper'

describe User do

  describe 'Associations' do

    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe 'Validations' do

    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
  end
end
