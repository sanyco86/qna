require 'rails_helper'

describe Answer do

  describe 'Validations' do

    it { should validate_presence_of :body }
  end

  describe 'Associations' do

    it { should belong_to :question }
    it { should belong_to :user }
  end
end