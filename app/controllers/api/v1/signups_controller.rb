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
    car_id = signup_params["car_id"]
    trip_id = signup_params["trip_id"]
    car = JoinACar.perform(car_id, trip_id, current_user)

    render json: car, status: :ok, serializer: CarSerializer,
      except: [:car, :cars, :google_identity, :signups]
  end

  private

  def signup_params
    params.require(:signup).permit(:trip_id, :car_id).merge(user: current_user)
  end
end
