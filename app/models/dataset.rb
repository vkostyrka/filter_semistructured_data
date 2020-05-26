class Dataset < ApplicationRecord
  belongs_to :user
  has_many :filters, dependent: :delete_all
  enum file_format: { csv: 0, json: 1 }
  mount_uploader :file, FileUploader

  def all_data
    if csv?
      CSV.read(file.file.file)[1..-1]
    elsif json?
      JSON.parse(File.read(file.file.file)).map(&:values)
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

  def data_for_filtered_ids(ids)
    if csv?
      CSV.read(file.file.file)[1..-1].values_at(*ids)
    elsif json?
      JSON.parse(File.read(file.file.file)).map(&:values).values_at(*ids)
    else
      raise 'Unknown format'
    end
  end

  def count_row
    if csv?
      CSV.read(file.file.file).count
    elsif json?
      JSON.parse(File.read(file.file.file)).count
    else
      raise 'Unknown format'
    end
  end
end
