class Api::V1::LocationsController < Api::V1::ApiController
  def create
    car = Car.find(location_params[:car_id])

    if !car.trip.upcoming?
      car.arrived!
    end

    if car.in_transit?
      authorize car, :create_location?

      if current_user == car.owner
        location = Location.create!(location_params)

        if car.near_destination?
          car.arrived!
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
    else
      raise CarNotInTransit
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
