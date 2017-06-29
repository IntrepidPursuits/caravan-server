class Api::V1::CarsController < Api::V1::ApiController
  def create
    raise InvalidCarCreation unless trip_id = car_params["trip_id"]
    authorize Trip.find(trip_id), :create_car?
    car = CreateACar.perform(car_params, current_user)
    render json: car, status: :created, serializer: CarSerializer, except: exclusions
  end

  def show
    car = Car.find(params[:id])
    authorize car
    render json: car, status: :ok, serializer: CarSerializer, except: exclusions
  end

  private

  def car_params
    params.require(:car).permit(:trip_id, :max_seats, :name, :status)
  end

  def exclusions
    [:car, :cars, :google_identity, :invite_code, :signups]
  end
end
