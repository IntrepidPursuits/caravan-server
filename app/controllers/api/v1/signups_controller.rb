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

  def update
    signup = Signup.find(params["id"])
    authorize signup
    signup_car = Car.find(signup_params["car_id"])
    car = JoinACar.perform(signup_car, signup, current_user)

    render json: car, status: :ok, serializer: CarSerializer, except: exclusions
  end

  private

  def signup_params
    params.require(:signup).permit(:car_id, :trip_id).merge(user: current_user)
  end

  def exclusions
    [:car, :cars, :google_identity, :signups]
  end
end
