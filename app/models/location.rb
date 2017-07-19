class Location < ApplicationRecord
  belongs_to :car
  has_one :trip, through: :car

  validates :car, presence: true

  validates :direction, numericality: { greater_than_or_equal_to: 0,
    less_than_or_equal_to: 360, only_integer: true }, presence: true

  validates :latitude, numericality: { greater_than_or_equal_to: -90,
    less_than_or_equal_to: 90 }, presence: true

  validates :longitude, numericality: { greater_than_or_equal_to: -180,
    less_than_or_equal_to: 180 }, presence: true

  def distance_to_destination
    Geocoder::Calculations.distance_between(
      [latitude, longitude],
      [trip.destination_latitude, trip.destination_longitude]
    )
  end
end
