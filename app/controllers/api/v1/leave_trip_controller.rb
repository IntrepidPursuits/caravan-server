class Api::V1::LeaveTripController < Api::V1::ApiController
  def destroy
    trip = Trip.find(params[:trip_id])
    signup = Signup.find_by(trip: trip, user: current_user)
    raise MissingSignup if signup.nil?

    current_user.owned_cars.each do |owned_car|
      if owned_car.trip == trip
        owned_car.destroy!
      end
    end
    
    signup.destroy!

    head :no_content
  end
end
