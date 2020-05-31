class Dataset < ApplicationRecord
  belongs_to :user
  has_many :filters, dependent: :delete_all
  enum file_format: { csv: 0, json: 1 }
  mount_uploader :file, FileUploader

  def all_data(count)
    if csv?
      CSV.foreach(file.file.file).take(count + 1)[1..-1]
    elsif json?
      JSON.parse(File.read(file.file.file)).map(&:values)[0...count]
    else
      raise 'Unknown format'
    end
  end

  def headers
    if csv?
      CSV.open(file.file.file, 'r', &:first)
    elsif json?
      JSON.parse(File.read(file.file.file))[0].keys
    else
      raise 'Unknown format'
    end
  end

  def data_for_filtered_ids(ids, count)
    if csv?
      all_data(ids[count]).values_at(*ids[0...count])
    elsif json?
      JSON.parse(File.read(file.file.file)).map(&:values).values_at(*ids)[0...count]
    else
      raise 'Unknown format'
    end
  end

  def calculate_rows
    if csv?
      CSV.read(file.file.file).count
    elsif json?
      JSON.parse(File.read(file.file.file)).count
    else
      raise 'Unknown format'
    end
  end

  def counts
    max_count = count_row
    i = 10
    counts = []

    while i < max_count
      counts << i
      i *= 10
    end
    counts << max_count
  end
end
