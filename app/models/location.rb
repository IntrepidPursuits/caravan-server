class Location < ApplicationRecord
  belongs_to :car
  has_one :trip, through: :car

  validates :car, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
end
