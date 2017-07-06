class CarSerializer < BaseSerializer
  attributes :max_seats,
    :name,
    :owner_id,
    :passengers,
    :status,
    :trip

  has_one :trip, serializer: SimpleTripSerializer

  has_many :locations
  has_many :signups
  has_many :users, through: :signups,
    serializer: PassengerSerializer, key: :passengers

  def passengers
    self.users
  end
end
