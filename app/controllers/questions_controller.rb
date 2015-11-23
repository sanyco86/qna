class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_own_question, only: [:update, :edit, :destroy]
  before_action :load_question, only: [:show]
  include Voted

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      flash[:success] =  'Question was successfully created.'
      PrivatePub.publish_to "/questions", question: render_to_string(template: 'questions/show.json.jbuilder')
    else
      render :new
    end
  end

  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.js
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    if @question.destroy
      respond_to do |format|
        format.html { redirect_to questions_path, notice: 'Answer was successfully destroyed.' }
        format.js
      end
    end
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