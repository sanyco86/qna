class CommentPolicy < ApplicationPolicy
  def create?
    user
  end
end
