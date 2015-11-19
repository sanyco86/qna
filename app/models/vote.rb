class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true
  scope :upvotes, -> { where(value: 1) }
  scope :downvotes, -> { where(value: -1) }
  scope :rating, -> { sum(:value)}
end