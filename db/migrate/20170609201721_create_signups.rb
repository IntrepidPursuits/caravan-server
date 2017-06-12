class CreateSignups < ActiveRecord::Migration[5.1]
  def change
    create_table :signups, id: :uuid do |t|
      t.uuid :trip_id, foreign_key: true, null: false, index: { unique: true, internal: :user_id }
      t.uuid :user_id, foreign_key: true, null: false, index: { unique: true, internal: :car_id }
      t.uuid :car_id, foreign_key: true, index: true
      t.timestamps
    end
  end
end
