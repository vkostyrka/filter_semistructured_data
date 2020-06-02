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

  FILTER_CONDITION = %w[or and].freeze

  class << self
    def get_filtered_data(filter_params, dataset, count)
      filter_ids = filter_params.split(Regexp.union(FILTER_CONDITION))
      conditions = filter_params.split(Regexp.union(filter_ids))
      conditions.shift

      raise 'Uncorrect ids and conditions count' if filter_ids.length != conditions.length + 1

      filter_result = make_complex_filter(filter_ids, conditions, dataset)

      dataset.data_for_filtered_ids(filter_result, count)
    end

    def filtered_ids(filter_id, dataset)
      return Filter.find(filter_id).filtered_id unless filter_id.to_i.zero?

      count_rows = dataset.count_row - 1
      (0...count_rows).to_a
    end

    def make_complex_filter(filter_ids, conditions, dataset)
      return Filter.filtered_ids(filter_ids[0], dataset) if conditions.empty?

      ids_from_first_filter = Filter.filtered_ids(filter_ids.shift, dataset)
      ids_from_second_filter = Filter.filtered_ids(filter_ids.shift, dataset)
      result = combine_filter(ids_from_first_filter, ids_from_second_filter, conditions.shift)
      return result if conditions.empty?

      until conditions.empty?
        new_filter = Filter.filtered_ids(filter_ids.shift, dataset)
        new_conditions = conditions.shift
        result = combine_filter(result, new_filter, new_conditions)
      end

      result
    end

    def combine_filter(first_filter, second_filter, condition)
      case condition
      when 'and' then first_filter & second_filter
      when 'or'  then (first_filter | second_filter).sort
      end
    end
  end

  def filter_name
    "#{column_name} #{condition} #{value}"
  end

  def filter_process
    filtered_id = []
    if dataset.csv?
      csv_parsed = CSV.read(dataset.file.file.file)
      headers = csv_parsed.shift
      filtered_column_index = headers.index(column_name)
      csv_parsed.each_with_index do |row, index|
        filtered_id << index if condition_fulfilled?(self, row[filtered_column_index])
      end
    elsif dataset.json?
      json_parsed = JSON.parse(File.read(dataset.file.file.file))
      json_parsed.each_with_index do |hash, index|
        filtered_id << index if condition_fulfilled?(self, hash[column_name])
      end
    else
      raise 'Unknown format for dataset'
    end
    update(filtered_id: filtered_id)
  end

  private

  def condition_fulfilled?(filter, field)
    case filter.condition
    when 'less'
      field.to_i < filter.value.to_i
    when 'equal'
      field.to_s == filter.value.to_s
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
