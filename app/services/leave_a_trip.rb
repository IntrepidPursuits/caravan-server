class LeaveATrip
  def initialize(trip, user)
    @trip = trip
    @user = user
    @signup = Signup.find_by(trip: @trip, user: @user)
    raise ArgumentError, "expected a user" unless @user.class == User
    raise ArgumentError, "expected a trip" unless @trip.class == Trip
    raise MissingSignup if @signup.nil?
  end

  def self.perform(trip, user)
    new(trip, user).perform
  end

  def perform
    Car.find_by(owner: @user, trip: @trip)&.destroy!
    @signup.destroy!
  end
end
