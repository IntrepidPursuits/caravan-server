class Trip < ApplicationRecord
  belongs_to :creator, class_name: :User
  has_many :cars
  has_many :user_trips
  has_many :users, through: :user_trips
end
