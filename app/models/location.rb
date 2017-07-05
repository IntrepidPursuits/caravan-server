class Location < ApplicationRecord
  belongs_to :car
  has_one :trip, through: :car

  validates_presence_of :car, :latitude, :longitude
end
