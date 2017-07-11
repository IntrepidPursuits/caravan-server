class Api::V1::TwitterAuthsController < Api::V1::ApiController
  def create
    user = TwitterAuthenticator.perform(auth_params[:token], auth_params[:token_secret])
    render json: user, status: :created, serializer: AuthSerializer
  end

  private

  def auth_params
      params.require(:auth).permit(:token, :token_secret)
  end
end
