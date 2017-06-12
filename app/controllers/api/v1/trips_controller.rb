class Api::V1::TripsController < ApplicationController
  def create
    invite_code = InviteCodeGenerator.new.invite_code
    trip_params_with_code = trip_params.merge(invite_code: invite_code)
    trip = Trip.create!(trip_params_with_code)
    render json: trip, status: :created
  end

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
