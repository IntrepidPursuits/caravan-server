class SimpleTripSerializer < BaseSerializer
  attributes :car_owners,
             :code,
             :creator,
             :departing_on,
             :destination_address,
             :destination_latitude,
             :destination_longitude,
             :name

  has_one :creator, class_name: :user
  has_one :invite_code

  has_many :car_owners, serializer: PassengerSerializer

  def code
    object.invite_code.code
  end
end
