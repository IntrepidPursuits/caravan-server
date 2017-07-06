class CarPolicy < ApplicationPolicy
  attr_reader :user, :car

  def initialize(user, car)
    @user = user
    @car = car
  end

  def create_location?
    user.cars.include?(car) && car.trip.users.include?(user)
  end

  def show?
    user.trips.include?(car.trip)
  end

  def update?
    user.cars.include?(car)
  end

  def leave_car?
    car.users.include?(user) && car.trip.users.include?(user)
  end
end
