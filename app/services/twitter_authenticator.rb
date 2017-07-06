class TwitterAuthenticator
  attr_reader :token, :token_secret

  def initialize(token, token_secret)
    @token = token
    @token_secret = token_secret
  end

  def self.perform(token, token_secret)
    new(token, token_secret).perform
  end

  def perform
    if token_validator.tokens_valid?
      twitter_identity = create_or_update_twitter_identity
      twitter_identity.user
    else
      raise UnauthorizedTwitterAccess
    end
  end

  private

  def create_or_update_twitter_identity
    if twitter_identity = TwitterIdentity.find_by(twitter_id: twitter_id)
      ActiveRecord::Base.transaction do
        twitter_identity.update_attributes(attrs_to_update)
        twitter_identity.user.update_attributes(name: token_hash[:name])
      end
      twitter_identity
    else
      TwitterIdentity.create(attrs_to_create)
    end
  end

  def token_validator
    @token_validator ||= TwitterTokenValidator.new(token, token_secret)
  end

  def twitter_id
    @twitter_id ||= token_hash[:twitter_id]
  end

  def attrs_to_update
    {
      image: token_hash[:image],
      screen_name: token_hash[:screen_name]
    }
  end

  def attrs_to_create
    {
      image: token_hash[:image],
      screen_name: token_hash[:screen_name],
      twitter_id: token_hash[:twitter_id],
      user: new_user
    }
  end

  def token_hash
    @token_hash ||= token_validator.token_hash
  end

  def new_user
    User.create(name: token_hash[:name])
  end
end
