class Seat < ApplicationRecord
  belongs_to :car
  belongs_to :user

  validates :car, presence: true
  validates :user, presence: true, uniqueness: { scope: :car_id }
end
