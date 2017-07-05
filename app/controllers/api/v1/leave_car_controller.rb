class Api::V1::LeaveCarController < Api::V1::ApiController
  def update
    raise ActionController::ParameterMissing unless car = signup.car
    authorize car, :leave_car?
    LeaveACar.perform(car, signup, current_user)
    head :no_content
  end

  private

  def signup
    Signup.find(params["signup_id"])
  end
end
