class QuestionsController < ApplicationController
  include Votable
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_own_question, only: [:update, :edit, :destroy]
  before_action :load_question, only: [:show, :upvote, :downvote, :unvote]

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
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      flash[:success] = 'Question was successfully updated.'
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if @question.destroy
      flash[:success] = 'Answer was successfully destroyed.'
      redirect_to questions_path
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
    @resource = @question
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def load_own_question
    load_question
    redirect_to root_url unless @question.user == current_user
  end
end
