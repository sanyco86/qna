class AnswerPolicy < ApplicationPolicy

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
