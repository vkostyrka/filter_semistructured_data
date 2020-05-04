class CreateFilters < ActiveRecord::Migration[6.0]
  def change
    create_table :filters do |t|
      t.integer :condition
      t.string :value
      t.belongs_to :dataset

      t.timestamps
    end
  end
end
