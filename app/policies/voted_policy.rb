module VotedPolicy
  extend ActiveSupport::Concern

  def upvote?
    user
  end

  def downvote?
    user
  end

  def unvote?
    user
  end
end