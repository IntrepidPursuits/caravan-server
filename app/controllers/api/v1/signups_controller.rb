class Api::V1::SignupsController < Api::V1::ApiController
  def create
    raise MissingInviteCodeError if params["invite_code"].nil? 
    if signup_params["trip_id"]
      trip = Trip.find(signup_params["trip_id"])
      raise InvalidInviteCodeError if !trip.valid_code?(params["invite_code"])
    end
    signup = Signup.create!(signup_params)
    render json: signup, serializer: SignupSerializer, status: :created
  end

  private

  def signup_params
    params.require(:signup).permit(:user_id, :trip_id)
  end
end
