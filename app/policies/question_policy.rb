class QuestionPolicy < ApplicationPolicy
  include VotedPolicy
  include SubscribedPolicy
  def create?
    user
  end

  def update?
    user && user.id == record.user_id
  end

  def destroy?
    user && user.id == record.user_id
  end
end
