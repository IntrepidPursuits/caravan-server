class TwitterTokenValidator
  attr_reader :token, :token_secret

  def initialize(token, token_secret)
    @token = token
    @token_secret = token_secret
  end

  def tokens_valid?
    errors.nil? && required_info_present?
  end

  def token_hash
    @token_hash ||= {
      image: parsed_response["profile_image_url"],
      name: parsed_response["name"],
      screen_name: parsed_response["screen_name"],
      twitter_id: parsed_response["id_str"]
    }
  end

  private

  def required_info_present?
    parsed_response["id_str"].present? && parsed_response["name"].present?
  end

  def response
    access_token = prepare_access_token(token, token_secret)
    @response ||= access_token.request(:get, "https://api.twitter.com/1.1/account/verify_credentials.json")
  end

  def prepare_access_token(token, token_secret)
      consumer = OAuth::Consumer.new(TWITTER_API_KEY, TWITTER_API_SECRET, { site: "https://api.twitter.com", scheme: :header })
      access_token_hash = { oauth_token: token, oauth_token_secret: token_secret }
      access_token = OAuth::AccessToken.from_hash(consumer, access_token_hash)
  end

  def errors
    parsed_response["errors"]
  end

  def parsed_response
    JSON.parse(response.body)
  end
end
