class Api::V1::CarsController < Api::V1::ApiController
  def create
    car = Car.create!(car_params)
    user = current_user
    Signup.create!(car_id: car.id, trip_id: car.trip_id, user_id: user.id)
    render json: car,
      status: :created,
      serializer: CarSerializer,
      except: [:car, :cars, :google_identity, :invite_code, :signups]
  end

  def show
    car = Car.find(params[:id])
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
