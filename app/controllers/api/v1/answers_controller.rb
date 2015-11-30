class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question

  def index
    respond_with @answers = @question.answers
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end
end
