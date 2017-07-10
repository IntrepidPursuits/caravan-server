class Api::V1::SignupsController < Api::V1::ApiController
  def create
    trip = Trip.find_by(invite_code: invite_code)
    signup = Signup.create!(trip: trip, user: current_user)
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

  def invite_code
    code = params["invite_code"]
    raise MissingInviteCodeError if code.nil?
    raise InvalidInviteCodeError unless invite_code = InviteCode.find_by(code: code)
    invite_code
  end
end
