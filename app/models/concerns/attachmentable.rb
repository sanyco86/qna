module Attachmentable
  extend ActiveSupport::Concern
  included do
    has_many :attachments, as: :attachmentable, dependent: :destroy
    accepts_nested_attributes_for :attachments, reject_if: ->(a) { a[:file].blank? }, allow_destroy: true
  end
end
