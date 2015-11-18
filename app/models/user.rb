class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy

  def vote_for(object, value)
    vote = self.votes.new(votable: object, value: value)
    vote.save unless self.voted_for?(object) || (self.id == object.user_id)
  end

  def unvote_for(object)
    self.votes.where(votable: object).destroy_all if self.voted_for? object
  end

  def voted_for?(object)
    self.votes.where(votable: object).any?
  end
end
