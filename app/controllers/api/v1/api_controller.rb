class Api::V1::ApiController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid do |exception|
    render json: { errors: exception.message }, status: :unprocessable_entity
  end

  rescue_from UnauthorizedAccess do |exception|
    render json: { errors: exception.message }, status: :unprocessable_entity
  end

  def current_user
    @current_user ||= warden&.user
  end

  def warden
    @warden ||= request.env["warden"]
  end
end
