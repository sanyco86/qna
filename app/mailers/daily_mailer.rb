class DailyMailer < ApplicationMailer
  def digest(user_id, question_ids = nil)
    @questions = Question.where(id: question_ids)
    @user = User.find(user_id)
    mail to: @user.email
  end
end
