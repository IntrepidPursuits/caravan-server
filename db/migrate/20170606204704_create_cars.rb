class CreateCars < ActiveRecord::Migration[5.1]
  def change
    create_table :cars, id: :uuid do |t|
      t.uuid :trip_id, foreign_key: true, null: false
      t.integer :num_seats
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
