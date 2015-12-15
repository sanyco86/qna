class AnswerPolicy < ApplicationPolicy
  include VotedPolicy
  def create?
    user
  end

  def update?
    user && user.id == record.user_id
  end

  def destroy?
    user && user.id == record.user_id
  end

  def make_best?
    user && !record.best && user.id == record.question.user_id unless record.best
  end
end
