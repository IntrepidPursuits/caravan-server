class PassengerSerializer < BaseSerializer
  attributes :name, :email

  has_one :google_identity
  has_many :signups
  has_one :car, through: :signups

  def email
    self.google_identity.email
  end
end
