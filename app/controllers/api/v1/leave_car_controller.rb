class Api::V1::LeaveCarController < Api::V1::ApiController
  def update
    car = Car.find(params["car_id"])
    authorize car, :leave_car?
    LeaveACar.perform(car, current_user)
    head :no_content
  end
end
