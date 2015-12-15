class Vote < ActiveRecord::Base
  include HasUser
  belongs_to :votable, polymorphic: true

  validates :user_id, uniqueness: { scope: [:votable_type, :votable_id] }

  scope :upvotes, -> { where(value: 1) }
  scope :downvotes, -> { where(value: -1) }
  scope :rating, -> { sum(:value) }
end
