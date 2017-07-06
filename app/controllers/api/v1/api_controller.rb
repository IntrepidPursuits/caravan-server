class Api::V1::ApiController < ApplicationController
  def current_user
    @current_user ||= warden&.user
  end

  def warden
    @warden ||= request.env["warden"]
  end

  [ActiveRecord::RecordInvalid,
    CarNotStartedError,
    InvalidCarCreation,
    InvalidCarJoin,
    InvalidInviteCodeError,
    UnauthorizedAccess].each do |error|
    rescue_from error do |exception|
       render json: { errors: exception.message }, status: :unprocessable_entity
    end
  end

  [MissingInviteCodeError, ArgumentError, ActionController::ParameterMissing].each do |error|
    rescue_from error do |exception|
      render json: { errors: exception.message }, status: :bad_request
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { errors: exception.message }, status: :not_found
  end

  rescue_from Pundit::NotAuthorizedError do |exception|
    render json: { errors: "User is not authorized to perform this action" },
           status: :forbidden
  end
end
