class Question < ActiveRecord::Base

  include Attachmentable
  include HasUser
  include HasVotable

  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  validates :title, :body, presence: true
end
