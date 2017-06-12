class CreateTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :trips, id: :uuid do |t|
      t.uuid :creator_id, foreign_key: true, null: false, index: true
      t.string :name, null: false, index: true, unique: true
      t.datetime :departing_on, null: false
      t.string :invite_code, null: false, index: true, unique: true
      t.string :destination_address, null: false
      t.decimal :destination_latitude, null: false
      t.decimal :destination_longitude, null: false
      t.timestamps
    end
  end
end
