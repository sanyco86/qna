class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, except: :show

  def index
    respond_with @answers = @question.answers
  end

  def show
    respond_with @answer = Answer.find(params[:id])
  end

  def create
    respond_with @answer = @question.answers.create(answer_params.merge(user: current_resource_owner))
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
