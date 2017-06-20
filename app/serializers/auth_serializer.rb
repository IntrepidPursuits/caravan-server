class AuthSerializer < ActiveModel::Serializer
  attributes :access_token, :user

  has_one :user

  def user
    object
  end

  def access_token
    EncodeJwt.perform(user: user)
  end

  def root
    "auth"
  end
end