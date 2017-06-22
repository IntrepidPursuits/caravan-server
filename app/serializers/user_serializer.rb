class UserSerializer < BaseSerializer
  attributes :name

  has_one :google_identity
end
