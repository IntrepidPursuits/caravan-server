class Api::V1::TripsController < Api::V1::ApiController
  def create
    invite_code = InviteCodeGenerator.perform
    trip_params_with_code = trip_params.merge(invite_code: invite_code)
    trip = Trip.create!(trip_params_with_code)
    Signup.create!(trip: trip, user: current_user)
    render json: trip,
           except: [:invite_code, :signups, :users],
           serializer: TripSerializer,
           status: :created
  end

  def index
    user = User.includes(:trips).find(params[:user_id])
    authorize user, :current_user?
    trips = user.trips
    render json: trips,
      each_serializer: UserTripSerializer,
      except: [:cars, :creator, :invite_code, :signups, :users],
      status: :ok
  end

  def show
    trip = Trip.find(params[:id])
    render json: trip,
           except: [:invite_code, :signups, :users],
           serializer: TripSerializer,
           status: :ok
  end

  private

  def trip_params
    params.require(:trip).permit(
      :departing_on,
      :destination_address,
      :destination_latitude,
      :destination_longitude,
      :name
    ).merge(
      creator: current_user
    )
  end
end
