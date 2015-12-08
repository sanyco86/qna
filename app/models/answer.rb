class Answer < ActiveRecord::Base

  include Attachmentable
  include HasUser
  include HasVotable

  belongs_to :question
  has_many :comments, as: :commentable, dependent: :destroy
  validates :body, :question_id, presence: true

  #after_commit :report_to_subscribers, on: [:create]

  default_scope -> { order(best: :desc).order(created_at: :asc) }

  scope :for_new_answer, -> { where('created_at > ?', 15.minutes.ago) }

  def make_best
    ActiveRecord::Base.transaction do
      self.question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  def self.send_report_new_answers
    questions_ids = Answer.for_new_answer.pluck(:question_id)
    answers_ids= Answer.for_new_answer.pluck(:id)

    questions = Question.where(id: questions_ids)
    questions.find_each do |question|
      question.subscribers.find_each do |subscriber|
        ReportNewAnswerWorker.perform_async(subscriber.id, answers_ids)
      end
    end
  end

  # private
  #
  # def report_to_subscribers
  #   question.subscribers.find_each do |subscriber|
  #     ReportWorker.perform_async(subscriber.id, self.id)
  #   end
  # end
end
