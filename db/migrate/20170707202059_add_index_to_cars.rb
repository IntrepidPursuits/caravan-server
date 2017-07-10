class AddIndexToCars < ActiveRecord::Migration[5.1]
  def change
    add_index :cars, [:owner_id, :trip_id], unique: true
  end
end
