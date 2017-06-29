class TokenAuthenticationStrategy < ::Warden::Strategies::Base
  def valid?
    env["HTTP_AUTHORIZATION"].present?
  end

  def store?
    false
  end

  def authenticate!
    success!(user)

  rescue JWT::ExpiredSignature
    fail!(I18n.t("warden.token_expired"))
  rescue ActiveRecord::RecordNotFound
    fail!(I18n.t("warden.user_not_found"))
  rescue JWT::DecodeError
    fail!("Invalid token")
  end

  def user
    User.find(user_id)
  end

  def user_id
    token_payload["sub"]
  end

  def token_payload
    HandleJwt.decode(access_token: access_token)
  end

  def access_token
    env["HTTP_AUTHORIZATION"].sub("Bearer ", "")
  end
end
