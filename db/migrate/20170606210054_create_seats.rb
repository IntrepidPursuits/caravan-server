class CreateSeats < ActiveRecord::Migration[5.1]
  def change
    create_table :seats, id: :uuid do |t|
      t.uuid :user_id, foreign_key: true, null: false
      t.uuid :car_id, foreign_key: true, null: false
      t.boolean :driver?
      t.timestamps
    end
    add_index :seats, :user_id, unique: true
    add_index :seats, :car_id, unique: true
  end
end
