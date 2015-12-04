class DailyMailer < ApplicationMailer

  def digest(user, question_ids=nil)
    @questions = Question.where(id: question_ids)

    mail to: user.email
  end
end
