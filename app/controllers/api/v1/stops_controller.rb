class Api::V1::StopsController < Api::V1::ApiController
  def create
    stop = Stop.create!(stop_params)

    render json: stop, status: :created
  end

  private

  def stop_params
    params.require(:stop).permit(
      :address,
      :name,
      :description,
      :latitude,
      :longitude,
      :trip_id
    )
  end
end
