class Location < ApplicationRecord
  belongs_to :car
  has_one :trip, through: :car

  validates :car, presence: true
  validates :direction, numericality: { greater_than_or_equal_to: -180,
    less_than_or_equal_to: 180, only_integer: true }, presence: true
  validates :latitude, numericality: true, presence: true
  validates :longitude, numericality: true, presence: true
end
