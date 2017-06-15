class Api::V1::TripsController < Api::V1::ApiController
  def create
    invite_code = InviteCodeGenerator.perform
    trip_params_with_code = trip_params.merge(invite_code: invite_code)
    trip = Trip.new(trip_params_with_code)
    if trip.save
      render json: trip, status: :created
    else
      raise InvalidTripError.new(trip)
    end
  end

  private

  def trip_params
    params.require(:trip).permit(
      :creator_id,
      :name,
      :departing_on,
      :destination_address,
      :destination_latitude,
      :destination_longitude
    )
  end
end
