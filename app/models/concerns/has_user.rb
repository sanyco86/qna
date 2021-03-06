module HasUser
  extend ActiveSupport::Concern
  included do
    belongs_to :user
    validates :user_id, presence: true
  end
end
