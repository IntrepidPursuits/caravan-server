class Api::V1::CarsController < Api::V1::ApiController
  def create
    ActiveRecord::Base.transaction do
      @car = Car.create!(car_params)
      signup = FindASignup.perform(@car.trip, current_user)
      signup.update_attributes(car: @car)
    end
    render json: @car, status: :created, serializer: CarSerializer, except: exclusions
  end

  def show
    car = Car.find(params[:id])
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
