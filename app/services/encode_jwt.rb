class EncodeJwt
  attr_reader :expiration_datetime, :user

  def initialize(user:, expiration_datetime: default_token_expiration_datetime)
    @user = user
    @expiration_datetime = expiration_datetime
  end

  def self.perform(argument)
    new(argument).perform
  end

  def perform
    JWT.encode payload, token_secret, "HS256"
  end

  private

  def payload
    {
      "sub": user.id,
      "exp": expiration_datetime.to_i
    }
  end

  def default_token_expiration_datetime
    30.day.from_now
  end

  def token_secret
    Rails.application.secrets.secret_key_base
  end
end
