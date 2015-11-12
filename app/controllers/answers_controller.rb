class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_own_answer, only: :destroy

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:notice] = 'Answer was successfully created'
      redirect_to @question
    else
      render 'questions/show'
    end
  end

  def destroy
    if @answer.destroy
      flash[:notice] = 'Answer was successfully destroyed'
      redirect_to @answer.question
    end
  end

  private

  def load_own_answer
    @answer = Answer.find params[:id]
    unless @answer.user == current_user
      redirect_to root_url
    end
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
