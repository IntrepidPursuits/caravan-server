class Trip < ApplicationRecord
  belongs_to :creator, class_name: :User
  has_many :cars
  has_many :user_trips
  has_many :users, through: :user_trips

  validates :departure_date, presence: true
  validates :destination_address, presence: true
  validates :destination_latitude, presence: true
  validates :destination_longitude, presence: true
  validates :invite_code, presence: true
  validates :name, presence: true, uniqueness: true
end
