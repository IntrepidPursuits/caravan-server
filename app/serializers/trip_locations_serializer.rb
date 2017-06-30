class TripLocationsSerializer < ActiveModel::Serializer
  attributes :trip_id, :last_locations

  has_many :cars
  has_many :last_locations, serializer: LocationSerializer

  def trip_id
    self.object.id
  end
end
