class FilterProcessJob < ApplicationJob
  queue_as :default

  def perform(filter)
    filter.filter_process
  end
end
