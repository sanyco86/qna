module SubscribedPolicy
  extend ActiveSupport::Concern

  def subscribe?
    user
  end

  def unsubscribe?
    user
  end
end