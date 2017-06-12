class CreateSignups < ActiveRecord::Migration[5.1]
  def change
    create_table :signups, id: :uuid do |t|
      t.uuid :trip_id, foreign_key: true, null: false
      t.uuid :user_id, foreign_key: true, null: false
      t.uuid :car_id, foreign_key: true, index: true
      t.timestamps
    end
    add_index :signups, [:trip_id, :user_id], unique: true
    add_index :signups, [:car_id, :user_id], unique: true
  end
end
