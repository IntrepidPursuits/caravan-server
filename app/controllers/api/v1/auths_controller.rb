class Api::V1::AuthsController < Api::V1::ApiController
  def create
    user, google_identity = GoogleAuthenticator.perform(auth_params[:token])

    render json: user, status: :created, serializer: AuthSerializer
  end

  private

  def auth_params
    params.require(:auth).permit(:token)
  end
end
