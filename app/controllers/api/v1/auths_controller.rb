class Api::V1::AuthsController < Api::V1::ApiController
  def create
    user, google_identity = GoogleAuthenticator.perform(auth_params[:token])

    if user.valid? && google_identity.valid?
      render json: user, status: :created, serializer: AuthSerializer
    end
  end

  private

  def auth_params
    params.require(:auth).permit(:token)
  end
end
