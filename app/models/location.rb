class Location < ApplicationRecord
  belongs_to :car
  has_one :trip, through: :car

  validates_numericality_of :direction, greater_than_or_equal_to: -180,
    less_than_or_equal_to: 180, only_integer: true
  validates_presence_of :car, :direction, :latitude, :longitude
end
