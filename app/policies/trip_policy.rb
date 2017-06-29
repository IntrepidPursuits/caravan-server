class TripPolicy < ApplicationPolicy
  attr_reader :user, :trip

  def initialize(user, trip)
    @user = user
    @trip = trip
  end

  def create_car?
    trip.users.include?(user)
  end

  def update_leave_car?
    trip.users.include?(user)
  end
end
