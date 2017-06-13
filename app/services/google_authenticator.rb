class GoogleAuthenticator
  attr_reader :token, :response, :google_identity

  def initialize(token)
    @token = token
  end

  def self.perform(token)
    new(token).perform
  end

  def perform
    raise Api::V1::ApiController::UnauthorizedAccess if !token_valid?
    google_identity = GoogleIdentity.find_or_create_by(attrs)
    user = google_identity.user
    # reset the token?
    [user, google_identity]
  end

  def token_valid?
    token_validator.perform
  end

  def token_validator
    @token_validator ||= GoogleTokenValidator.new(token)
  end

  def parsed_token
    parsed_token = JSON.parse(token)["token"]
  end

  def attrs
    @attrs ||= {
      email: google_profile["email"],
      image: google_profile["picture"],
      token: token,
      token_expires_at: Date.today + 5,
      uid: google_uid,
      user: user
    }
  end

  def token_hash
    @token_hash = token_validator.token_hash
  end

  def google_profile
    @google_profile ||= GoogleProfileRequest.perform(google_uid)
  end

  def google_uid
    @google_uid ||= token_hash[:google_uid]
  end

  def user
    user = User.find_or_create_by(name: google_profile["name"])
  end
end
