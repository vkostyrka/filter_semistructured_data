class GetFilteredDataService
  class << self
    def build(filter_params)
      filter = Filter.find(filter_params)
      CSV.read(filter.dataset.file.file.file)[1..-1].values_at(*filter.filtered_id)
    end
  end
end
