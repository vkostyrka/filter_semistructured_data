class ChangeColumnForDataset < ActiveRecord::Migration[6.0]
  def change
    rename_column :datasets, :format, :file_format
  end
end
