class Dataset < ApplicationRecord
  belongs_to :user
  has_many :filters, dependent: :delete_all
  enum file_format: { csv: 0, json: 1 }
  mount_uploader :file, FileUploader
end
