class CreateUserTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :user_trips, id: :uuid do |t|
      t.belongs_to :user
      t.belongs_to :trip
      t.timestamps
    end
  end
end
