class Question < ActiveRecord::Base

  include Attachmentable
  include HasUser
  include HasVotable

  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscribe_lists, dependent: :destroy
  has_many :subscribers, class_name: 'User', through: :subscribe_lists
  validates :title, :body, presence: true

  scope :for_today, -> { where(created_at: Date.today.beginning_of_day..Date.today.end_of_day) }

  after_create :subscribe_author

  def subscribe(user)
    self.subscribers << user unless has_subscribed? user
  end

  def unsubscribe(user)
    self.subscribers.delete(user) if has_subscribed? user
  end

  def has_subscribed?(user)
    subscribers.include? user
  end

  private

  def subscribe_author
    subscribe(user)
  end
end
