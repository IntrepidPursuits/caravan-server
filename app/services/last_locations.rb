class LastLocations
  def self.perform(cars)
    new(cars).perform
  end

  def initialize(cars)
    @cars = cars
  end

  def perform
    @cars.map do |car|
      car.locations.order("updated_at").last
    end
  end
end
