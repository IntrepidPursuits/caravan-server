class Api::V1::CarsController < Api::V1::ApiController
  def create
    car = Car.create!(car_params)
    render json: car, status: :created, serializer: CarSerializer, except: [:cars, :signups, :users]
  end

  def show
    car = Car.find(params[:id])
    render json: car, status: :ok, serializer: CarSerializer, except: [:cars, :signups, :users]
  end

  private

  def car_params
    params.require(:car).permit(:trip_id, :max_seats, :name, :status)
  end
end
