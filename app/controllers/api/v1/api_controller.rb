class Api::V1::ApiController < ApplicationController
  class UnauthorizedAccess < StandardError
    def message
      'Unauthorized Client ID'
    end
  end

  def current_user
    @current_user ||= warden&.user
  end

  def warden
    @warden ||= request.env["warden"]
  end

  [InvalidTripError].each do |error|
     rescue_from error do |exception|
       render json: { errors: exception.message }, status: :bad_request
    end
  end
end
