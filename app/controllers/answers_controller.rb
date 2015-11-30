class AnswersController < ApplicationController

  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :make_best]
  after_action :publish_answer, only: :create
  include Voted

  respond_to :js, :json

  def create
    @question = Question.find(params[:question_id])
    respond_with @answer = @question.answers.create(answer_params.merge(user: current_user))
    authorize @answer
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def make_best
    @question = @answer.question
    @answer.make_best if @question.user_id == current_user.id
  end

  def destroy
    respond_with @answer.destroy
  end

  private

  def publish_answer
    PrivatePub.publish_to chanel, answer: render_to_string(template: 'answers/show') if @answer.valid?
  end

  def chanel
    "/questions/#{@question.id}/answers"
  end

  def load_answer
    @answer = Answer.find params[:id]
    @question = @answer.question
    authorize @answer
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end
