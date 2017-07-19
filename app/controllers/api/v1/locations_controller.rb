class Api::V1::LocationsController < Api::V1::ApiController
  def create
    car = Car.find(location_params[:car_id])
    raise CarNotInTransit unless car.status == "in_transit"

    trip_ended = car.trip.departing_on < DateTime.now.beginning_of_day
    if trip_ended
      car.update!(status: "arrived")
    end

    authorize car, :create_location?

    if current_user == car.owner && !trip_ended
      location = Location.create!(location_params)
      if location.distance_to_destination < 0.1
        car.update!(status: "arrived")
      end
      render json: location.trip,
             except: [:car, :cars],
             serializer: TripLocationsSerializer,
             status: :created
    else
      render json: car.trip,
             except: [:car, :cars],
             serializer: TripLocationsSerializer,
             status: :ok
    end
  end

  def index
    trip = Trip.find(params[:trip_id])
    authorize trip, :index_locations?
    render json: trip,
           except: [:car, :cars],
           serializer: TripLocationsSerializer
  end

  private

  def location_params
    params.require(:location).permit(
      :direction,
      :latitude,
      :longitude
    ).merge(
      car_id: params[:car_id]
    )
  end
end
