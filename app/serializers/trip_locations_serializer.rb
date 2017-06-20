class TripLocationsSerializer < ActiveModel::Serializer
  attributes :trip_id, :last_locations

  has_many :cars
  has_many :locations, through: :cars

  def trip_id
    self.object.id
  end
end
