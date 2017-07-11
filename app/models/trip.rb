class Trip < ApplicationRecord
  belongs_to :creator, class_name: :User
  belongs_to :invite_code

  has_many :cars
  has_many :locations, through: :cars
  has_many :signups
  has_many :users, through: :signups

  validates_numericality_of :destination_latitude, :destination_longitude
  validates_presence_of :creator, :departing_on, :destination_address,
    :destination_latitude, :destination_longitude, :invite_code_id, :name
  validates_uniqueness_of :invite_code_id

  def last_locations
    self.cars.map { |car| car.locations.order("updated_at").last }.compact
  end
end
