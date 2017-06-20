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
    google_identity = GoogleIdentity.find_by(uid: google_uid)
    if google_identity
      google_identity.update_attributes(attrs_to_update)
      google_identity.user.update_attributes(name: token_hash[:name])
    else
      google_identity = GoogleIdentity.create(attrs_to_create)
    end
    user = google_identity.user
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

  def attrs_to_update
    {
      email: token_hash[:email],
      image: token_hash[:image]
    }
  end

  def attrs_to_create
    {
      email: token_hash[:email],
      image: token_hash[:image],
      uid: google_uid,
      user: new_user
    }
  end

  def token_hash
    @token_hash = token_validator.token_hash
  end

  def google_uid
    @google_uid ||= token_hash[:google_uid]
  end

  def new_user
    new_user = User.create(name: token_hash[:name])
  end
end
