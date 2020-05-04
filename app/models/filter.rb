class Filter < ApplicationRecord
  belongs_to :dataset
  enum condition: { more: 0, less: 1, equal: 2, include: 3 }
end
