class TripSerializer < BaseSerializer
  attributes :cars,
             :code,
             :creator,
             :departing_on,
             :destination_address,
             :destination_latitude,
             :destination_longitude,
             :name

  has_one :creator
  has_one :invite_code
  has_many :cars, serializer: CarSerializer

  def code
    object.invite_code.code
  end
end
