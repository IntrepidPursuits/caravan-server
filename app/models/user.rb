class User < ApplicationRecord
  has_many :trips, as: :creator
  has_many :cars, through: :seats
  has_many :seats
  has_many :trips, through: :user_trips
  has_many :user_trips
end
