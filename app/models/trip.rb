class Trip < ApplicationRecord
  belongs_to :creator, class_name: :User
  belongs_to :invite_code

  has_many :cars
  has_many :locations, through: :cars
  has_many :signups
  has_many :users, through: :signups

  validates :destination_latitude, numericality: { greater_than_or_equal_to: -90,
    less_than_or_equal_to: 90 }, presence: true

  validates :destination_longitude, numericality: { greater_than_or_equal_to: -180,
    less_than_or_equal_to: 180 }, presence: true

  validates :invite_code_id, presence: true, uniqueness: true
  
  validates_presence_of :creator, :departing_on, :destination_address, :name

  def last_locations
    self.cars.map { |car| car.locations.order("updated_at").last }.compact
  end
end
