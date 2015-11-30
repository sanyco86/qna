class Attachment < ActiveRecord::Base
  belongs_to :attachmentable, polymorphic: true

  mount_uploader :file, AttachmentUploader
  delegate :url, to: :file

  validates :file, presence: true
end
