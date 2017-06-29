class UserTripSerializer < SimpleTripSerializer
  attributes :signup_id

  def signup_id
    signup = Signup.find_by(trip_id: self.id, user: self.scope)
    signup.id
  end
end
