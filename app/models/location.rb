class Location < ApplicationRecord
  belongs_to :car
  belongs_to :stop, optional: true
  has_one :trip, through: :car

  validates_numericality_of :direction, greater_than_or_equal_to: -180,
    less_than_or_equal_to: 180, only_integer: true
  validates_presence_of :car, :direction, :latitude, :longitude
  validates_uniqueness_of :stop, scope: :car_id, allow_nil: true
end
