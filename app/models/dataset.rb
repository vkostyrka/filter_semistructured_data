class Dataset < ApplicationRecord
  belongs_to :user
  enum format: %i[csv]
  mount_uploader :file, FileUploader
end
