class Api::V1::QuestionsController < Api::V1::BaseController
  after_action :load_authorize, except: :index

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    respond_with @question = Question.find(params[:id])
  end

  def create
    respond_with @question = current_resource_owner.questions.create(question_params)
  end

  private
  def load_authorize
    authorize @question
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
