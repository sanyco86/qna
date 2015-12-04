class Question < ActiveRecord::Base

  include Attachmentable
  include HasUser
  include HasVotable

  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  validates :title, :body, presence: true

  scope :for_today, -> { where(created_at: Date.today.beginning_of_day..Date.today.end_of_day) }
end
