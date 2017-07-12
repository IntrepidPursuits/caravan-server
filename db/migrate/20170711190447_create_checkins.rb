class CreateCheckins < ActiveRecord::Migration[5.1]
  def change
    create_table :checkins, id: :uuid do |t|
      t.uuid :car_id, foreign_key: true, null: false
      t.uuid :stop_id, foreign_key: true, null: false
      t.boolean :currently_checked_in?, default: true, null: false
      t.timestamps
    end
    add_index :checkins, :car_id
    add_index :checkins, :stop_id
    add_index :checkins, [:car_id, :stop_id], unique: true
  end
end
