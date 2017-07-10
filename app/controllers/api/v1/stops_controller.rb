class Api::V1::StopsController < Api::V1::ApiController
  def create
    trip = Trip.find(params[:trip_id])
    authorize trip, :create_stop?
    stop = Stop.create!(stop_params)

    render json: stop, status: :created
  end

  private

  def stop_params
    params.require(:stop)
      .permit(:address, :name, :description, :latitude, :longitude)
      .merge(trip_id: params[:trip_id])
  end
end
