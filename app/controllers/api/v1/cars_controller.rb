class Api::V1::CarsController < Api::V1::ApiController
  def create
    car = Car.create!(car_params)
    render json: car,
      status: :created,
      serializer: CarSerializer,
      except: [:car, :cars, :google_identity, :invite_code, :signups]
  end

  def show
    car = Car.find(params[:id])
    if !current_user.trips.include?(car.trip)
      raise UserNotAuthorizedError
    end
    render json: car,
      status: :ok,
      serializer: CarSerializer,
      except: [:car, :cars, :google_identity, :invite_code, :signups]
  end

  private

  def car_params
    params.require(:car).permit(:trip_id, :max_seats, :name, :status)
  end
end
