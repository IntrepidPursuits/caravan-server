class UserSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_one :google_identity
end
