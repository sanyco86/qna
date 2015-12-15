class Question < ActiveRecord::Base

  include Attachmentable
  include HasUser
  include HasVotable

  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, class_name: 'User', through: :subscriptions
  validates :title, :body, presence: true

  default_scope -> { order(created_at: :asc) }
  scope :for_today, -> { where(created_at: Time.zone.yesterday.to_time.all_day) }

  after_create :subscribe_author

  def subscribe(user)
    self.subscribers << user unless subscribed? user
  end

  def unsubscribe(user)
    self.subscribers.delete(user) if subscribed? user
  end

  def subscribed?(user)
    subscribers.include? user
  end

  private

  def subscribe_author
    subscribe(user)
  end
end
