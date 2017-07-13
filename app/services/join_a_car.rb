class JoinACar
  attr_reader :car, :user
  attr_accessor :signup

  def initialize(car, user)
    @car = car
    @user = user
  end

  def self.perform(car, user)
    new(car, user).perform
  end

  def perform
    if @signup = Signup.find_by(trip: car.trip, user: user)
      sign_up_user
    else
      raise MissingSignup
    end
  end

  private

  def sign_up_user
    if !user_already_signed_up? && !user_owns_signed_up_car?
      signup.update_attributes!(car: car)
    elsif user_owns_signed_up_car?
      raise UserOwnsCarError
    end
  end

  def user_already_signed_up?
    car == signup.car
  end

  def user_owns_signed_up_car?
    signup.car.is_a?(Car) && signup.car.owner == user
  end
end
