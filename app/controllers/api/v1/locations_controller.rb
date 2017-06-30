class Api::V1::LocationsController < Api::V1::ApiController
  def create
    car = Car.find(location_params["car_id"])
    raise CarNotStartedError.new if car.status == "not_started"
    authorize car, :create_location?
    location = Location.create!(location_params)
    render json: location.trip,
           except: [:cars, :locations, :signups, :users],
           serializer: TripLocationsSerializer,
           status: :created
  end

  def index
    trip = Trip.find(params[:trip_id])
    render json: trip,
           except: [:car, :cars],
           serializer: TripLocationsSerializer
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
