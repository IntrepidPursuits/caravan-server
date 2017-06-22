class Api::V1::TripsController < Api::V1::ApiController
  def create
    invite_code = InviteCodeGenerator.perform
    trip_params_with_code = trip_params.merge(invite_code: invite_code)
    trip = Trip.create!(trip_params_with_code)
    render json: trip, serializer: TripSerializer, status: :created
  end

  def index
    user = User.find(params[:user_id])
    raise UserNotAuthorizedError if user.id != current_user.id
    trips = user.trips
    render json: trips,
      except: [:cars, :creator, :invite_code, :signups, :users],
      each_serializer: SimpleTripSerializer,
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
