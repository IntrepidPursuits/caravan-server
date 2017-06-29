class CreateACar
  def initialize(params, user)
    @params = params
    @user = user
    @trip = params["trip_id"]
  end

  def self.perform(params, user)
    new(params, user).perform
  end

  def perform
    car = Car.create!(@params)
    raise MissingSignup unless signup = Signup.find_by(trip: @trip, user: @user)
    signup.update_attributes(car: car)
    car
  end
end
