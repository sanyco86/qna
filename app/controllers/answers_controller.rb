class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_own_answer, only: [:show, :update, :make_best, :destroy]

  def show
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      render json: render_to_string(template: 'answers/show.json.jbuilder')
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
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
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end
