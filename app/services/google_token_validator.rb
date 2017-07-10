class GoogleTokenValidator
  attr_reader :token, :response

  def initialize(token)
    @token = token
  end

  def self.perform(token)
    new(token).perform
  end

  def perform
    return false if token_invalid? || !client_id_valid? || missing_required_info?
    token_hash
    true
  end

  def token_invalid?
    response["error_description"] == "Invalid Value"
  end

  def client_id_valid?
    VALID_GOOGLE_CLIENT_IDS.include?(client_id)
  end

  def missing_required_info?
    response["sub"].nil? || response["email"].nil? || response["name"].nil?
  end

  def client_id
    response["aud"]
  end

  def token_hash
    @token_hash ||= { google_uid: response["sub"], email: response["email"], name: response["name"], image: response["picture"] }
  end

  def response
    url = "https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{token}"
    @response ||= HTTParty.get(url).parsed_response
  end
end
