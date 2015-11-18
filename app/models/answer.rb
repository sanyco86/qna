class Answer < ActiveRecord::Base

  include Attachmentable
  include HasUser
  has_many :votes, as: :votable, dependent: :destroy

  belongs_to :question

  validates :body, :question_id, presence: true

  default_scope -> { order(best: :desc).order(created_at: :asc) }

  def make_best
    ActiveRecord::Base.transaction do
      self.question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
