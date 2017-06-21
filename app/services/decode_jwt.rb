class DecodeJwt
  attr_reader :access_token

  def self.perform(argument)
    new(argument).perform
  end

  def initialize(access_token)
    @access_token = access_token
  end

  def perform
    JWT.decode(access_token, token_secret, "HS256").first
  end

  private

  def token_secret
    Rails.application.secrets.secret_key_base
  end
end
