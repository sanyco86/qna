module Votable
  extend ActiveSupport::Concern
  included do
    def vote_for(object, value)
      vote = votes.new(votable: object, value: value)
      vote.save
    end

    def unvote_for(object)
      votes.where(votable: object).delete_all
    end

    def voted_for?(object)
      votes.where(votable: object).any?
    end
  end
end
