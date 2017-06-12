class Trip < ApplicationRecord
  belongs_to :creator, class_name: :User
  has_many :cars
  has_many :signups
  has_many :users, through: :signups

  validates :departing_on, presence: true
  validates :destination_address, presence: true
  validates :destination_latitude, presence: true
  validates :destination_longitude, presence: true
  validates :invite_code, presence: true
  validates :name, presence: true, uniqueness: true
end
