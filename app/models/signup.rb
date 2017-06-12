class Signup < ApplicationRecord
  belongs_to :car, optional: true
  belongs_to :trip
  belongs_to :user

  validates :trip, uniqueness: { scope: :user_id }, presence: true
  validates :user, uniqueness: { scope: :car_id }, presence: true
end
