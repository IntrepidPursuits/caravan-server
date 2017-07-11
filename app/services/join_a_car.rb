class JoinACar
  def initialize(car, signup, user)
    @car = car
    @signup = signup
    @user = user
  end

  def self.perform(car, signup, user)
    new(car, signup, user).perform
  end

  def perform
    return @car if @car == @signup.car
    raise InvalidCarJoin unless @car.is_a?(Car) && @car.trip == @signup.trip
    raise UserOwnsCarError if owned_car
    @signup.update_attributes!(car: @car)
    @car
  end

  def owned_car
    @signup.car.is_a?(Car) && @signup.car.owner == @user
  end
end
