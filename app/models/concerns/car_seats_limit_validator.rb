class CarSeatsLimitValidator < ActiveModel::Validator
  def validate(signup)
    if signup.car_id
      car = Car.find(signup.car_id)
      if car.signups.length >= car.max_seats
        signup.errors.add :car, "is full! Sorry!"
      end
    end
  end
end
