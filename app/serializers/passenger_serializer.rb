class PassengerSerializer < ActiveModel::Serializer
  attributes :id, :name, :email

  has_one :google_identity

  def email
    self.google_identity.email
  end
end
