class ReportMailer < ApplicationMailer
  default template_path: 'mailers/report_mailer'

  def report(user_id, answer_id)
    @user = User.find(user_id)
    @answer = Answer.find(answer_id)
    @question = @answer.question

    mail to: @user.email
  end
end
