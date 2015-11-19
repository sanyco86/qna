class AnswersController < ApplicationController

  before_action :authenticate_user!
  before_action :load_own_answer, only: [:update, :destroy]
  before_action :load_answer, only: [:show, :make_best]
  include Votable

  def show
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      render :show
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    @question = @answer.question
    if @answer.update(answer_params)
      render :show
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def make_best
    @question = @answer.question
    @answer.make_best if @question.user_id == current_user.id
  end

  def destroy
    @answer.destroy
  end

  private

  def load_answer
    @answer = Answer.find params[:id]
  end

  def load_own_answer
    load_answer
    redirect_to root_url unless @answer.user == current_user
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end
