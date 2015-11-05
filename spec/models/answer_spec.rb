require 'rails_helper'

describe Answer do

  it { should validate_presence_of :body }
  it { should belong_to :question }
  it { should belong_to :user }
end
