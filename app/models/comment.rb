class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  include HasUser

  validates :body, presence: true

  default_scope { order(created_at: :asc) }
end