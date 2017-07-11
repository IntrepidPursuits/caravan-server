class PassengerSerializer < BaseSerializer
  attributes :name, :email, :image

  has_one :google_identity

  def email
    object.google_identity.email
  end

  def image
    object.google_identity.image
  end
end
