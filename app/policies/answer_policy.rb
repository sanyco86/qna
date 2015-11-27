class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def update?
    user == record.user
  end

  def destroy?
    user == record.user
  end

  def make_best?
    user == record.question.user and not record.best
  end
end
