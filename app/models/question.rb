class Question < ActiveRecord::Base

  include Attachmentable
  include HasUser
  include HasVotable

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
end
