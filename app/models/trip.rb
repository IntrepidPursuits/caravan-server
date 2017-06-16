class Trip < ApplicationRecord
  belongs_to :creator, class_name: :User
  belongs_to :invite_code

  has_many :cars
  has_many :locations, through: :cars
  has_many :signups
  has_many :users, through: :signups

  validates :creator, presence: true
  validates :departing_on, presence: true
  validates :destination_address, presence: true
  validates :destination_latitude, presence: true
  validates :destination_longitude, presence: true
  validates :invite_code_id, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
