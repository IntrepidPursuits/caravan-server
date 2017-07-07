class Car < ApplicationRecord
  belongs_to :owner, class_name: :User
  belongs_to :trip

  has_many :locations
  has_many :signups
  has_many :users, through: :signups

  enum status: {
    not_started: 0,
    in_transit: 1,
    arrived: 2
  }

  validates_associated :signups

  validates_numericality_of :max_seats, { in: [1..10] }
  validates_presence_of :max_seats, :name, :owner, :status, :trip
  validates_uniqueness_of :name, { scope: :trip_id }
end
