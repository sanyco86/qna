class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_own_question, only: [:update, :edit, :destroy]
  before_action :load_question, only: [:show]
  include Voted

  respond_to :json, :js

  def index
    respond_with @questions = Question.all
  end

  def show
    respond_with @question
  end

  def new
    respond_with @question = Question.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      flash[:success] =  'Question was successfully created.'
      redirect_to @question
      PrivatePub.publish_to "/questions", question: render_to_string(template: 'questions/show.json.jbuilder')
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with @question.destroy
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def load_own_question
    load_question
    unless @question.user == current_user
      render text: 'You do not have permission to modify this question.', status: 403
    end
  end
end