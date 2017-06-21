class WardenFailureController < ActionController::Metal
  include AbstractController::Rendering
  include ActionController::ApiRendering
  include ActionController::ConditionalGet
  include ActionController::Renderers::All

  def self.call(env)
    @respond ||= action(:respond)
    @respond.call(env)
  end

  def respond
    response.headers["WWW-Authenticate"] = header_content
    head :unauthorized
  end

  private

  def error_message
    @error_message ||= request.env["warden"].message
  end

  def header_content
    content = %(Bearer realm="Application")
    if error_message.present?
      content += %(, error="invalid_token", error_description="#{error_message}")
    end
    content
  end
end
