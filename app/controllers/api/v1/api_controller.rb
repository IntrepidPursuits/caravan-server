class Api::V1::ApiController < ApplicationController
  def current_user
    @current_user ||= warden&.user
  end

  def warden
    @warden ||= request.env["warden"]
  end

  [ActiveRecord::RecordInvalid, CarNotStartedError, InvalidInviteCodeError, UnauthorizedAccess].each do |error|
    rescue_from error do |exception|
       render json: { errors: exception.message }, status: :unprocessable_entity
    end
  end

  [MissingInviteCodeError, ArgumentError].each do |error|
    rescue_from error do |exception|
      render json: { errors: exception.message }, status: :bad_request
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { errors: exception.message }, status: :not_found
  end
end
