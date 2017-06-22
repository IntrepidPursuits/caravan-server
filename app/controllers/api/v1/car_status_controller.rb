class Api::V1::CarStatusController < Api::V1::ApiController
  def update
    car = Car.find(params[:car_id])
    if Signup.where(car: car, trip: car.trip, user: current_user).empty?
      raise UserNotAuthorizedError
    end
    car.update_attributes(status: params[:status])
    render json: car,
      status: :ok,
      serializer: CarSerializer,
      except: [:car, :cars, :google_identity, :invite_code, :signups]
  end
end
