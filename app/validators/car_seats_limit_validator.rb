class CarSeatsLimitValidator < ActiveModel::Validator
  def validate(signup)
    car = signup.car
    if car.signups.count >= car.max_seats
      signup.errors.add :car, "is full! Sorry!"
    end
  end
end
