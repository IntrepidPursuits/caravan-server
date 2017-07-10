class Api::V1::LeaveTripController < Api::V1::ApiController
  def destroy
    trip = Trip.find(params[:trip_id])
    LeaveATrip.perform(trip, current_user)
    head :no_content
  end
end
