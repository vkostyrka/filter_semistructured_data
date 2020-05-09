class AddFilteredIdToFilter < ActiveRecord::Migration[6.0]
  def change
    add_column :filters, :filtered_id, :integer, array: true, default: []
  end
end
