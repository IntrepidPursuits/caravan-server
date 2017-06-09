class Signup < ApplicationRecord
  belongs_to :car, optional: true
  belongs_to :trip
  belongs_to :user

  validates :car, uniqueness: { scope: :user_id }
  validates :user, uniqueness: { scope: :trip_id }
  validates :user_id, presence: true
  validates :trip_id, presence: true
end
