class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_own_answer, only: [:update, :make_best, :destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def make_best
    @question = @answer.question
    @answer.make_best if @question.user_id == current_user.id
  end

  def destroy
    @answer.destroy
  end

  private

  def load_own_answer
    @answer = Answer.find params[:id]
    unless @answer.user == current_user
      redirect_to root_url
    end
  end

  def answer_params
    params.require(:answer).permit(
                                    :body,
                                    :question_id,
                                    attachments_attributes: [:file]
    )
  end
end
