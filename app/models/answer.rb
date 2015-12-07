class Answer < ActiveRecord::Base

  include Attachmentable
  include HasUser
  include HasVotable

  belongs_to :question
  has_many :comments, as: :commentable, dependent: :destroy
  validates :body, :question_id, presence: true

  after_create :report_to_subscribers

  default_scope -> { order(best: :desc).order(created_at: :asc) }

  def make_best
    ActiveRecord::Base.transaction do
      self.question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  private

  def report_to_subscribers
    question.subscribers.find_each do |subscriber|
      ReportWorker.perform_async(subscriber.id, self.id)
    end
  end
end
