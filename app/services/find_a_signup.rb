class FindASignup < Api::V1::ApiController
  def initialize(trip, user)
    @trip = trip
    @user = user
  end

  def self.perform(trip, user)
    new(trip, user).perform
  end

  def perform
    raise UserNotAuthorizedError unless signup = Signup.find_by(trip: @trip, user: @user)
    signup
  end
end
