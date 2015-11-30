class AnswerPolicy < ApplicationPolicy
  include VotedPolicy
  def create?
    user == user
  end

  def update?
    user && user.id == record.user_id
  end

  def destroy?
    user && user.id == record.user_id
  end

  def make_best?
    user && user.id == record.question.user_id and not record.best
  end
end
