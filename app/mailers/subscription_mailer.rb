class SubscriptionMailer < ApplicationMailer
  def report(question, user, answers)
    @user = user
    @question = question
    @answers = Answer.where(id: answers)

    mail to: @user.email
  end
end
