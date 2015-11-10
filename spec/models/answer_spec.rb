require 'rails_helper'

describe Answer do

  describe 'Associations' do

    it { should belong_to :question }
  end

  describe 'Validations' do

    it { should validate_presence_of :body }
    it { should validate_presence_of :question_id }
  end
end
