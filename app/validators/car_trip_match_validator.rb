class CarTripMatchValidator < ActiveModel::Validator
  def validate(signup)
    car = signup.car
    if car.trip != signup.trip
      signup.errors.add :car, "must belong to the Signup's trip"
    end
  end
end
