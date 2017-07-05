class RemoveTripNameIndex < ActiveRecord::Migration[5.1]
  def up
    remove_index :trips, :name
  end

  def down
    add_index :trips, :name, unique: true
  end
end
