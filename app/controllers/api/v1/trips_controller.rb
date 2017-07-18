class Api::V1::TripsController < Api::V1::ApiController
  def create
    invite_code = InviteCodeGenerator.perform
    trip_params_with_code = trip_params.merge(invite_code: invite_code)
    trip = Trip.create!(trip_params_with_code)
    Signup.create!(trip: trip, user: current_user)
    render json: trip,
           except: [:invite_code],
           serializer: TripSerializer,
           status: :created
  end

  def index
    user = User.includes(:trips).find(params[:user_id])
    authorize user, :current_user?
    trips = user.upcoming_trips
    render json: trips,
      except: [:creator, :invite_code],
      each_serializer: SimpleTripSerializer,
      status: :ok
  end

  def show
    trip = Trip.find(params[:id])
    render json: trip,
           except: [:google_identity, :invite_code, :locations, :trip],
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
