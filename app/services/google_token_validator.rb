class GoogleTokenValidator
  attr_reader :token, :name, :image, :response

  def initialize(token, name, image)
    @token = token
    @name = name
    @image = image
  end

  def self.perform(token, name, image)
    new(token, name, image).perform
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

  def client_id
    response["aud"]
  end

  def missing_required_info?
    noName = name.nil? && response["name"].nil?
    uid.nil? || response["email"].nil? || noName
  end

  def token_hash
    @token_hash ||= { google_uid: uid, email: response["email"], name: response["name"], image: response["picture"] }
    if !name.nil?
      @token_hash[:name] = name
      @token_hash[:image] = image
    end
    @token_hash
  end

  def uid
    response["sub"]
  end

  def response
    url = "https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{token}"
    @response ||= HTTParty.get(url).parsed_response
  end
end
