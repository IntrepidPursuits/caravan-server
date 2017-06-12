class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations, id: :uuid do |t|
      t.uuid :car_id, foreign_key: true, null: false, index: true
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false
      t.timestamps
    end
  end
end
