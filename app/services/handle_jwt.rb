class HandleJwt
  def self.encode(user, expires_at = 30.days.from_now)
    new.encode(user, expires_at)
  end

  def encode(user, expires_at)
    JWT.encode payload(user, expires_at), secret, "HS256"
  end

  def self.decode(access_token)
    new.decode(access_token)
  end

  def decode(access_token)
    JWT.decode(access_token, secret, "HS256").first
  end

  private

  def payload(user, expires_at)
    {
      "sub": user.id,
      "exp": expires_at.to_i
    }
  end

  def secret
    Rails.application.secrets.secret_key_base
  end
end
