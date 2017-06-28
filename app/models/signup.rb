class Signup < ApplicationRecord
  belongs_to :car, optional: true
  belongs_to :trip
  belongs_to :user

  validates_presence_of :trip, :user
  validates_uniqueness_of :car, scope: :user_id, allow_nil: true
  validates_uniqueness_of :trip, scope: :user_id
end
