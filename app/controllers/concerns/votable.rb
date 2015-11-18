module Votable
  extend ActiveSupport::Concern

  def upvote
    current_user.vote_for(@resource, 1)
    render :vote
  end

  def downvote
    current_user.vote_for(@resource, -1)
    render :vote
  end

  def unvote
    current_user.unvote_for(@resource)
    render :vote
  end
end