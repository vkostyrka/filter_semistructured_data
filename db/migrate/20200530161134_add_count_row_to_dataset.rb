class AddCountRowToDataset < ActiveRecord::Migration[6.0]
  def change
    add_column :datasets, :count_row, :integer, default: 0
  end
end
