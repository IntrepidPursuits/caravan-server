class Stop < ApplicationRecord
  belongs_to :trip
  has_many :locations
  has_many :cars, through: :locations

  validates_presence_of :trip
  validates :address, uniqueness: { scope: :trip_id }
  validates :name, uniqueness: { scope: :trip_id }
end
