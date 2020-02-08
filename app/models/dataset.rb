class Dataset < ApplicationRecord
  belongs_to :user
  enum format: %i[csv]
end
