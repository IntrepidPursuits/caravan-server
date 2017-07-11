class Stop < ApplicationRecord
  belongs_to :trip
  has_many :checkins
  has_many :cars, through: :checkins

  validates :address, presence: true, uniqueness: { scope: :trip_id }
  validates :name, presence: true, uniqueness: { scope: :trip_id }
  validates :latitude, numericality: true, presence: true
  validates :longitude, numericality: true, presence: true
  validates :trip, presence: true
end
