class CarPolicy < ApplicationPolicy
  attr_reader :user, :car

  def initialize(user, car)
    @user = user
    @car = car
  end

  def create_location?
    user.cars.include?(car)
  end

  def show?
    user.trips.include?(car.trip)
  end

  def update?
    user.cars.include?(car)
  end
end
