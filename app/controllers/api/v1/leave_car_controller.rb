class Api::V1::LeaveCarController < Api::V1::ApiController
  def update
    raise ActionController::ParameterMissing unless car = signup.car
    authorize car, :leave_car?
    signup.update_attributes!(car: nil)
    render json: car, status: :ok, serializer: CarSerializer, except: exclusions
  end

  private

  def exclusions
    [:car, :cars, :google_identity, :signups]
  end

  def signup
    Signup.find(params["signup_id"])
  end
end