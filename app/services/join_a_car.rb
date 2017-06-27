class JoinACar < Api::V1::ApiController
  def initialize(car_id, trip_id, user)
    @car_id = car_id
    @trip_id = trip_id
    @user = user
  end

  def self.perform(car_id, trip_id, user)
    new(car_id, trip_id, user).perform
  end

  def perform
    trip = Trip.find(@trip_id)
    signup = FindASignup.perform(trip, @user)
    if car = Car.find(@car_id)
      raise ActiveRecord::RecordInvalid if car.trip != trip
      signup.update_attributes(car: car)
    end
    car
  end
end
