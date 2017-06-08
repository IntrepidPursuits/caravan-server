class CreateSeats < ActiveRecord::Migration[5.1]
  def change
    create_table :seats, id: :uuid do |t|
      t.uuid :user_id, foreign_key: true, null: false
      t.uuid :car_id, foreign_key: true, null: false
      t.boolean :driver?, default: false, null: false
      t.timestamps
    end
    add_index :seats, :user_id
    add_index :seats, :car_id
    add_index :seats, [:car_id, :user_id], unique: true
  end
end
