class Checkin < ApplicationRecord
  belongs_to :car
  belongs_to :stop

  validates_presence_of :car, :stop, :currently_checked_in?
  validates_uniqueness_of :car, scope: :stop_id
end
