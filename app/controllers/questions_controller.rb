class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :edit, :destroy, :subscribe, :unsubscribe]
  after_action :publish_question, only: :create
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
    authorize @question
  end

  def edit
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
    authorize @question
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with @question.destroy
  end

  def subscribe
    @question.subscribe(current_user)
    redirect_to @question, notice: 'Subscribed successfully!'
  end

   def unsubscribe
    @question.unsubscribe(current_user)
    redirect_to @question, notice: 'Unsubscribed successfully!'
  end

  private

  def publish_question
    PrivatePub.publish_to "/questions", question: render_to_string(template: 'questions/show.json.jbuilder') if @question.valid?
  end

  def load_question
    @question = Question.find(params[:id])
    authorize @question
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end