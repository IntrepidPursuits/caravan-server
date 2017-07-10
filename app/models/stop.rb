class Stop < ApplicationRecord
  belongs_to :trip
  has_many :locations
  has_many :cars, through: :locations

  validates_presence_of :trip
end
