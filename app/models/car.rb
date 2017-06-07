class Car < ApplicationRecord
  belongs_to :trip
  has_many :seats
  has_many :users, through: :seats

  enum status: {
    "Not started": 0,
    "In transit": 1,
    "Arrived": 2
  }

  validates :status, inclusion: { in: statuses.keys }
  validates :num_seats, range: [1..25]
end
