require 'rails_helper'

RSpec.describe Attachment, type: :model do
  it { should belong_to :attachmentable }

  it { should validate_presence_of :file }
  it { should validate_presence_of :attachmentable }
end