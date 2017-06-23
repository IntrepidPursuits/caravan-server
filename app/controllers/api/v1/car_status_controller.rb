class Api::V1::CarStatusController < Api::V1::ApiController
  def update
    car = Car.find(params[:car_id])
    car.update_attributes(status: params[:status])
    render json: car,
      status: :ok,
      serializer: CarSerializer,
      except: [:car, :cars, :google_identity, :invite_code, :signups]
  end
end
