class User < ApplicationRecord
  has_one :google_identity
  has_one :twitter_identity

  has_many :created_trips, class_name: :Trip, foreign_key: :creator_id
  has_many :owned_cars, class_name: :Car, foreign_key: :owner_id
  has_many :signups
  has_many :cars, through: :signups
  has_many :trips, through: :signups
end
