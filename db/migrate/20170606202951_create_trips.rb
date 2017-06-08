class CreateTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :trips, id: :uuid do |t|
      t.uuid :creator_id, foreign_key: true, null: false
      t.string :name, null: false
      t.datetime :departure_date, null: false
      t.string :invite_code, null: false
      t.string :destination_address, null: false
      t.decimal :destination_latitude, null: false
      t.decimal :destination_longitude, null: false
      t.timestamps
    end
    add_index :trips, :creator_id
    add_index :trips, :name, unique: true
  end
end
