class AddOwnersToCars < ActiveRecord::Migration[5.1]
  def change
    add_column :cars, :owner_id, :uuid, foreign_key: true, null: false, index: true
  end
end
