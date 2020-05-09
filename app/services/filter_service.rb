require 'csv'

class FilterService
  class << self
    def build(filter)
      if filter.dataset.csv?
        csv_parsed = CSV.read(filter.dataset.file.file.file)
        headers = csv_parsed.shift
        filtered_column_index = headers.index(filter.column_name)
        filtered_id = []
        csv_parsed.each_with_index do |row, index|
          filtered_id << index if condition_fulfilled?(filter, row[filtered_column_index])
        end
        filter.update(filtered_id: filtered_id)
      end
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
end
