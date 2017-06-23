class EncodeJwt
  attr_reader :expires_at, :user

  def initialize(user:, expires_at: 30.days.from_now)
    @user = user
    @expires_at = expires_at
  end

  def self.perform(argument)
    new(argument).perform
  end

  def perform
    JWT.encode payload, secret, "HS256"
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
