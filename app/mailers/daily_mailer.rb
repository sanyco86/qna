class DailyMailer < ApplicationMailer
  default template_path: 'mailers/daily_mailer'

  def digest(user_id, question_ids=nil)
    @questions = Question.where(id: question_ids)
    @user = User.find(user_id)
    mail to: @user.email
  end
end
