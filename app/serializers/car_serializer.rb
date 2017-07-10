class CarSerializer < BaseSerializer
  attributes :max_seats,
    :name,
    :owner_id,
    :passengers,
    :seats_remaining,
    :status,
    :trip

  has_one :trip, serializer: SimpleTripSerializer

  has_many :locations
  has_many :signups
  has_many :users, through: :signups,
    serializer: PassengerSerializer, key: :passengers

  def passengers
    object.users
  end
end
