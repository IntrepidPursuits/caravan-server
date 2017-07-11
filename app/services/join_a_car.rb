class JoinACar
  attr_reader :car, :user
  attr_accessor :signup

  def initialize(car, signup, user)
    @car = car
    @signup = signup
    @user = user
  end

  def self.perform(car, signup, user)
    new(car, signup, user).perform
  end

  def perform
    return car if car == signup.car
    raise InvalidCarJoin unless car_matches_trip?
    raise UserOwnsCarError if user_owns_signed_up_car?
    signup.update_attributes!(car: car)
    car
  end

  private

  def car_matches_trip?
    car.is_a?(Car) && car.trip == signup.trip
  end

  def user_owns_signed_up_car?
    signup.car.is_a?(Car) && signup.car.owner == user
  end
end
