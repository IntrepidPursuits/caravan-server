class ChangeDataTypeOnUserTrips < ActiveRecord::Migration[5.1]
  def up
    remove_belongs_to :user_trips, :user
    remove_belongs_to :user_trips, :trip
    add_reference :user_trips, :user, type: :uuid, foreign_key: true
    add_reference :user_trips, :trip, type: :uuid, foreign_key: true
  end

  def down
    remove_reference :user_trips, :user
    remove_reference :user_trips, :trip
    add_belongs_to :user_trips, :user
    add_belongs_to :user_trips, :trip
  end
end
