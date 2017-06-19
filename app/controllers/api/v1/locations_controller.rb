class Api::V1::LocationsController < Api::V1::ApiController
  def create
    location = Location.create!(location_params)
    render json: location.trip,
           except: [:cars, :locations, :signups, :users],
           serializer: TripLocationsSerializer,
           status: :created
  end

  private

  def location_params
    params.require(:location).permit(
      :latitude,
      :longitude
    ).merge(
      car_id: params[:car_id]
    )
  end
end
