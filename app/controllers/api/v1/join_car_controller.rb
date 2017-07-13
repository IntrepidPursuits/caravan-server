class Api::V1::JoinCarController < Api::V1::ApiController
  def update
    car = Car.find(params[:car_id])
    authorize car, :join_car?
    JoinACar.perform(car, current_user)
    render json: car,
           serializer: CarSerializer,
           status: :ok,
           except: [:car, :cars, :google_identity, :invite_code, :locations, :signups]
  end
end
