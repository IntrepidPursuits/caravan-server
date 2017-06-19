class AddNameToCars < ActiveRecord::Migration[5.1]
  def change
    add_column :cars, :name, :string, null: false
    add_index :cars, [:name, :trip_id], unique: true
  end
end
