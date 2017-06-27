class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  include Pundit
end
