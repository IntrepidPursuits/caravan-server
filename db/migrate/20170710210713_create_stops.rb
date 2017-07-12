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
    add_index :stops, [:address, :trip_id], unique: true
    add_index :stops, [:name, :trip_id], unique: true
    add_index :stops, :trip_id
  end
end
