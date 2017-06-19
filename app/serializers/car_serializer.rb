class CarSerializer < ActiveModel::Serializer
  attributes :id,
    :max_seats,
    :name,
    :passengers,
    :status,
    :trip

  has_one :trip

  has_many :locations
  has_many :signups
  has_many :users, through: :signups, serializer: PassengerSerializer, except: [:google_identity]

  def passengers
    self.users
  end
end
