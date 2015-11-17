class Attachment < ActiveRecord::Base
  belongs_to :attachmentable, polymorphic: true

  mount_uploader :file, AttachmentUploader

  validates :file, presence: true
end
