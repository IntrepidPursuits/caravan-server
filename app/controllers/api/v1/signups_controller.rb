class Api::V1::SignupsController < Api::V1::ApiController
  def create
    signup = Signup.create!(signup_params)
    render json: signup, serializer: SignupSerializer, status: :created
  end

  private

  def signup_params
    params.require(:signup).permit(:user_id, :trip_id)
  end
end
