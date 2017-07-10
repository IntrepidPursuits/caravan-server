class CreateStops < ActiveRecord::Migration[5.1]
  def change
    create_table :stops, id: :uuid do |t|
      t.uuid :trip_id, foreign_key: true, null: false
      t.string :name, null: false
      t.string :address, null: false
      t.text :description
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false
      t.timestamps
    end
    add_column :locations, :stop_id, :uuid, foreign_key: true
    add_index :locations, :stop_id
    add_index :stops, :trip_id
  end
end
