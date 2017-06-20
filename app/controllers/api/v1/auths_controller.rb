class Api::V1::AuthsController < Api::V1::ApiController
  def create
    user, google_identity = GoogleAuthenticator.perform(params[:auth][:token])
    give them a token that i create

    render json: user, status: :created if user.valid? && google_identity.valid?
    # render with my token i just gave them
    # credential serializer
    # token and exp. date
  end
end
