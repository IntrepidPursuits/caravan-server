class UserTrip < ApplicationRecord
  belongs_to :trip
  belongs_to :user

  validates :user, uniqueness: { scope: :trip_id }
end
