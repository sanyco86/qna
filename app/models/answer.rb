class Answer < ActiveRecord::Base
  include Attachmentable
  include HasUser
  include HasVotable

  belongs_to :question, touch: true
  has_many :comments, as: :commentable, dependent: :destroy
  validates :body, :question_id, :user_id, presence: true

  default_scope -> { order(best: :desc).order(created_at: :asc) }

  scope :for_notification, -> { where(created_at: 15.minutes.ago.beginning_of_minute..1.minute.ago.end_of_minute) }

  def make_best
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  def self.notify_new_answers
    q2a = Answer.for_notification.group_by(&:question_id)

    Question.where(id: q2a.keys).includes(:subscribers).find_each { |q| q.subscribers.find_each { |user| SubscriptionMailer.report(q, user, q2a[q.id]).deliver_now } }
  end
end
