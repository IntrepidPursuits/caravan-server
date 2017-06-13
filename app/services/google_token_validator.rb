class GoogleTokenValidator
  attr_reader :token, :response

  def initialize(token)
    @token = token
  end

  def self.perform(token)
    new(token).perform
  end

  def perform
    return false if !client_id_valid?
    token_hash
    true
  end

  def token_hash
    @token_hash ||= { google_uid: response["sub"], email: response["email"] }
  end

  def response
    url = "https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{token}"
    @response ||= HTTParty.get(url).parsed_response
  end

  def client_id_valid?
    VALID_GOOGLE_CLIENT_IDS.include?(client_id)
  end

  def client_id
    response["aud"]
  end
end
