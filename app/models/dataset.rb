class Dataset < ApplicationRecord
  belongs_to :user
  enum file_format: { csv: 0 }
  mount_uploader :file, FileUploader
end
