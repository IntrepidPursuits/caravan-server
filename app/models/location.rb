class Location < ApplicationRecord
  belongs_to :car
  has_one :trip, through: :car

  validates_inclusion_of :direction, in: -180..180, :message => "must be between -180 & 180"
  validates_numericality_of :direction, only_integer: true
  validates_presence_of :car, :direction, :latitude, :longitude
end
