class LocationSerializer <  BaseSerializer
  attributes :car_id, :car_name, :latitude, :longitude

  has_one :car

  def car_name
    self.car.name
  end
end
