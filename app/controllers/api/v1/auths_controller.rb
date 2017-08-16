class Api::V1::AuthsController < Api::V1::ApiController
  def create
    user, google_identity = GoogleAuthenticator.perform(auth_values)
    render json: user, status: :created, serializer: AuthSerializer
  end

  private

  def auth_values
    JSON.parse(auth_params.to_json).symbolize_keys
  end

  def auth_params
    params.require(:auth).permit(:token, :name, :image)
  end
end
