class CreateFilters < ActiveRecord::Migration[6.0]
  def change
    create_table :filters do |t|
      t.integer :condition
      t.string :value
      t.string :column_name
      t.belongs_to :dataset

      t.timestamps
    end
  end
end
