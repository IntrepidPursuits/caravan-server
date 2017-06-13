class Api::V1::AuthsController < Api::V1::ApiController
  def create
    user, google_identity = GoogleAuthenticator.perform(params[:auth][:token])

    render json: user, status: :created if user.valid? && google_identity.valid?
  end
end
