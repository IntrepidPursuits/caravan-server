class FixUniqueness < ActiveRecord::Migration[5.1]
  def up
    remove_index :seats, :car_id
    add_index :seats, :car_id

    remove_index :seats, :user_id
    add_index :seats, :user_id

    add_index :seats, [:car_id, :user_id], unique: true

    remove_index :trips, :creator_id
    add_index :trips, :creator_id
  end

  def down
    remove_index :seats, :car_id
    add_index :seats, :car_id, unique: true

    remove_index :seats, :user_id
    add_index :seats, :user_id, unique: true

    remove_index :seats, [:car_id, :user_id]

    remove_index :trips, :creator_id
    add_index :trips, :creator_id, unique: true
  end
end
