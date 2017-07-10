class AddDirectionToLocations < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :direction, :integer, null: false, default: 0
  end
end
