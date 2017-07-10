class Car < ApplicationRecord
  belongs_to :owner, class_name: :User
  belongs_to :trip

  has_many :locations
  has_many :stops, through: :locations
  has_many :signups
  has_many :users, through: :signups

  enum status: {
    not_started: 0,
    in_transit: 1,
    arrived: 2
  }

  validates_numericality_of :max_seats, {
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 10,
    only_integer: true
  }
  validates_presence_of :max_seats, :name, :owner, :status, :trip
  validates_uniqueness_of :name, { scope: :trip_id }
  validates_uniqueness_of :owner, { scope: :trip_id, message: "User already owns a car for this trip" }

  def seats_remaining
    max_seats - users.count
  end
end
