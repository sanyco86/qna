class ReportNewAnswerMailer < ApplicationMailer
  default template_path: 'mailers/report_new_answer_mailer'

  def report_new_answer(user_id, answers_ids=nil)
    @user = User.find(user_id)
    @answers = Answer.where(id: answers_ids)
    @questions = @user.questions

    mail to: @user.email
  end
end
