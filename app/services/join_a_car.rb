class JoinACar < Api::V1::ApiController
  def initialize(car, signup, user)
    @car = car
    @signup = signup
    @user = user
  end

  def self.perform(car, signup, user)
    new(car, signup, user).perform
  end

  def perform
    raise ActiveRecord::RecordInvalid if !@car.is_a?(Car) || @car.trip != @signup.trip
    @signup.update_attributes(car: @car)
    @car
  end
end
