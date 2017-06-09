class CreateCars < ActiveRecord::Migration[5.1]
  def change
    create_table :cars, id: :uuid do |t|
        t.uuid :trip_id, foreign_key: true, null: false
        t.integer :max_seats, default: 1, null: false
        t.integer :status, default: 0, null: false
      t.timestamps
    end
    add_index :cars, :trip_id
  end
end
