class HandleJwt
  attr_reader :access_token, :expires_at, :user

  def initialize(access_token: nil, user: nil, expires_at: nil)
    @access_token = access_token
    @expires_at = expires_at
    @user = user
  end

  def self.encode(user: user, expires_at: 30.days.from_now)
    new(user: user, expires_at: 30.days.from_now).encode
  end

  def encode(user: user, expires_at: 30.days.from_now)
    JWT.encode(payload, secret, "HS256")
  end

  def self.decode(access_token: access_token)
    new(access_token: access_token).decode
  end

  def decode(access_token: access_token)
    JWT.decode(access_token, secret, "HS256").first
  end

  private

  def payload
    {
      "sub": user.id,
      "exp": expires_at.to_i
    }
  end

  def secret
    Rails.application.secrets.secret_key_base
  end
end
