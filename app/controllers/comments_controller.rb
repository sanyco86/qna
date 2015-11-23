class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :assign_commentable

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      PrivatePub.publish_to "/questions/#{@commentable.try(:question).try(:id) || @commentable.id}/comments", comment: render_to_string(template: 'comments/show')
      render nothing: true
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def assign_commentable
    @commentable_parent, @commentable_child = find_commentable
    @commentable = @commentable_child || @commentable_parent
  end

  def find_commentable
    commentable = []
    params.each do |name, value|
      if name =~ /(.+)_id$/
        commentable.push($1.classify.constantize.find(value))
      end
    end
    return commentable[0], commentable[1] if commentable.length > 1
    return commentable[0], nil if commentable.length == 1
    nil
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
