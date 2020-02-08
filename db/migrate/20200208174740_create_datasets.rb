class CreateDatasets < ActiveRecord::Migration[6.0]
  def change
    create_table :datasets do |t|
      t.integer :format, null: false
      t.belongs_to :user

      t.timestamps
    end
  end
end
