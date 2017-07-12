class Stop < ApplicationRecord
  belongs_to :trip
  has_many :checkins
  has_many :cars, through: :checkins

  validates :address, presence: true, uniqueness: { scope: :trip_id }

  validates :name, length: { maximum: 50 }, presence: true,
    uniqueness: { scope: :trip_id }

  validates :latitude, numericality: { greater_than_or_equal_to: -90,
    less_than_or_equal_to: 90 }, presence: true

  validates :longitude, numericality: { greater_than_or_equal_to: -180,
    less_than_or_equal_to: 180 }, presence: true

  validates :trip, presence: true
end
