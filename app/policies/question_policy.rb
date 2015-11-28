class QuestionPolicy < ApplicationPolicy

  alias_method :update?, :edit?

  def update?
    user && user.id == record.user_id
  end

  def destroy?
    user && user.id == record.user_id
  end
end
