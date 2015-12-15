class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      PrivatePub.publish_to chanel, comment: render_to_string(template: 'comments/show')
      render nothing: true
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def chanel
    "/questions/#{@commentable.try(:question).try(:id) || @commentable.id}/comments"
  end

  def load_commentable
    @commentable = commentable_name.find(params[commentable_id])
    authorize @commentable
  end

  def commentable_id
    (params[:commentable].singularize + '_id').to_sym
  end

  def commentable_name
    params[:commentable].classify.constantize
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
