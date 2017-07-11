class Stop < ApplicationRecord
  belongs_to :trip
  has_many :locations
  has_many :cars, through: :locations

  validates :address, presence: true, uniqueness: { scope: :trip_id }
  validates :name, presence: true, uniqueness: { scope: :trip_id }
  validates :latitude, numericality: true, presence: true
  validates :longitude, numericality: true, presence: true
  validates :trip, presence: true
end
