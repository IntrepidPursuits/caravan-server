class Api::V1::TripsController < ApplicationController
  def create
    trip = Trip.new(trip_params)
    render json: trip, status: :created
  end

  def trip_params
    params.require(:trip).permit(
      :creator_id,
      :name,
      :invite_code,
      :departing_on,
      :destination_address,
      :destination_latitude,
      :destination_longitude
    )
  end
end
