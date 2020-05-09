class Filter < ApplicationRecord
  belongs_to :dataset
  enum condition: {
    more: 0,
    less: 1,
    equal: 2,
    more_or_equal: 3,
    less_or_equal: 4,
    include: 5,
    start_with: 6
  }

  def filter_name
    "#{self.column_name} #{self.condition} #{self.value}"
  end
end
