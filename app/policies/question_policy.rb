class QuestionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  alias_method :update?, :edit?

  def update?
    user == record.user
  end

  def destroy?
    user == record.user
  end
end
