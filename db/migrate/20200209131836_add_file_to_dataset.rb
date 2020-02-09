class AddFileToDataset < ActiveRecord::Migration[6.0]
  def change
    add_column :datasets, :file, :string
  end
end
