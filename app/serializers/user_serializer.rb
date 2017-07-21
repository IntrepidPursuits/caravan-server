class UserSerializer < BaseSerializer
  attributes :name

  has_one :google_identity
  has_one :twitter_identity
end
