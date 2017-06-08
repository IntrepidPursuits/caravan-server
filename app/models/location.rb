class Location < ApplicationRecord
  belongs_to :car

  validates_presence_of :latitude, presence: true
  validates :longitude, presence: true
end
