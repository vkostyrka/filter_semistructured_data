require 'csv'

class Filter < ApplicationRecord
  belongs_to :dataset
  enum condition: {
    more: 0,
    less: 1,
    equal: 2,
    include: 3,
    start_with: 4
  }

  def self.get_filtered_data(filter_params)
    filter = Filter.find(filter_params)
    CSV.read(filter.dataset.file.file.file)[1..-1].values_at(*filter.filtered_id)
  end

  def filter_name
    "#{column_name} #{condition} #{value}"
  end

  def filter_process
    return unless dataset.csv?

    csv_parsed = CSV.read(dataset.file.file.file)
    headers = csv_parsed.shift
    filtered_column_index = headers.index(column_name)
    filtered_id = []
    csv_parsed.each_with_index do |row, index|
      filtered_id << index if condition_fulfilled?(self, row[filtered_column_index])
    end
    update(filtered_id: filtered_id)
  end

  private

  def condition_fulfilled?(filter, field)
    case filter.condition
    when 'less'
      field.to_i < filter.value.to_i
    when 'equal'
      field == filter.value
    when 'more'
      field.to_i > filter.value.to_i
    when 'include'
      field.include?(filter.value)
    when 'start_with'
      field.start_with?(filter.value)
    else
      false
    end
  end
end
