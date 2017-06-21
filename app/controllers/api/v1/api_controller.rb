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

  rescue_from MissingInviteCodeError do |exception|
    render json: { errors: exception.message }, status: :bad_request
  end
end
