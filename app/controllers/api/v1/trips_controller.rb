class Api::V1::TripsController < ApplicationController
  def create
    trip = Trip.new(trip_params)
    if trip.save
      render json: trip, status: :created
    end
  end

  private

  def trip_params
    params.require(:trip).permit(
      :creator_id,
      :name,
      :invite_code,
      :departure_date,
      :destination_address,
      :destination_latitude,
      :destination_longitude
    )
  end
end
