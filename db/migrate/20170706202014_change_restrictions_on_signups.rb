class ChangeRestrictionsOnSignups < ActiveRecord::Migration[5.1]
  def up
    remove_index :signups, [:car_id, :trip_id]
    add_index :signups, [:car_id, :user_id], unique: true
    add_index :signups, :trip_id
    add_index :signups, :user_id
  end

  def down
    add_index :signups, [:car_id, :trip_id], unique: true
    remove_index :signups, [:car_id, :user_id]
    remove_index :signups, :trip_id
    remove_index :signups, :user_id
  end
end
