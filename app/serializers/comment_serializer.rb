class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :commentable_type, :commentable_id, :created_at, :updated_at
end
