class CarTripMatchValidator < ActiveModel::Validator
  def validate(signup)
    if signup.car.trip != signup.trip
      signup.errors.add :car, "must belong to the Signup's trip"
    end
  end
end
