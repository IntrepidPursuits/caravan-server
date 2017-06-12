class Car < ApplicationRecord
  belongs_to :trip

  has_many :locations
  has_many :signups
  has_many :users, through: :signups

  enum status: {
    not_started: 0,
    in_transit: 1,
    arrived: 2
  }

  validates :max_seats, presence: true, numericality: { equal_to: 1 }
  validates :status, presence: true
  validates :trip, presence: true
end
