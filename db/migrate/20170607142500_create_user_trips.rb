class CreateUserTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :user_trips, id: :uuid do |t|
      t.uuid :user_id, foreign_key: true, null: false
      t.uuid :trip_id, foreign_key: true, null: false
      t.timestamps
    end
    add_index :user_trips, :user_id
    add_index :user_trips, :trip_id
    add_index :user_trips, [:user_id, :trip_id], unique: true
  end
end
