class User < ApplicationRecord
  has_one :google_identity

  has_many :created_trips, class_name: :Trip, as: :creator
  has_many :signups
  has_many :cars, through: :signups
  has_many :trips, through: :signups
end
