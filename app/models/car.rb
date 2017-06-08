class Car < ApplicationRecord
  belongs_to :trip
  has_many :locations
  has_many :seats
  has_many :users, through: :seats

  enum status: {
    not_started: 0,
    in_transit: 1,
    arrived: 2
  }

  validates :num_seats, presence: true, inclusion: { in: 1..25 }
  validates :status, presence: true
  validates :trip, presence: true

  def seats_filled
    self.seats.count
  end
end
