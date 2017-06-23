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
    trip = Trip.find(signup_params["trip_id"])
    raise UserNotAuthorizedError unless signup = Signup.find_by(trip: trip, user: current_user)
    if car = Car.find(signup_params["car_id"])
      raise ActiveRecord::RecordInvalid if car.trip != trip
      signup.update_attributes(car_id: car.id)
    end

    render json: car, status: :ok, serializer: CarSerializer,
      except: [:car, :cars, :google_identity, :signups]
  end

  private

  def signup_params
    params.require(:signup).permit(:trip_id, :car_id).merge(user: current_user)
  end
end
