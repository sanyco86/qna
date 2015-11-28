class QuestionPolicy < ApplicationPolicy

  alias_method :update?, :edit?

  def update?
    user == record.user
  end

  def destroy?
    user == record.user
  end
end
