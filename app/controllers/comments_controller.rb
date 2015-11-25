class CommentsController < ApplicationController
  respond_to :js, :json

  before_action :authenticate_user!
  before_action :load_commentable
  after_action :publish_comment

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)), template: 'comments/show')
  end

  private

  def publish_comment
    PrivatePub.publish_to "/questions/#{@commentable.try(:question).try(:id) || @commentable.id}/comments", comment: render_to_string(template: 'comments/show') if @comment.valid?
  end

  def load_commentable
    @commentable = commentable_name.find(params[commentable_id])
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
