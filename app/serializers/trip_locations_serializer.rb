class TripLocationsSerializer < ActiveModel::Serializer
  attributes :trip_id, :last_locations

  has_many :cars
  has_many :locations, through: :cars

  def trip_id
    self.object.id
  end

  def last_locations
    last_locations = []
    self.cars.each do |car|
      last_locations << car.locations.order("updated_at").last
    end
    last_locations
  end
end
