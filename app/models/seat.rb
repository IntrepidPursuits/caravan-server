class Seat < ApplicationRecord
  belongs_to :car
  belongs_to :user

  validates :driver?, presence: true
  validates :user, uniqueness: { scope: :car_id }
end
