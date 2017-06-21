class SimpleTripSerializer < ActiveModel::Serializer
  attributes :cars,
             :code,
             :creator,
             :departing_on,
             :destination_address,
             :destination_latitude,
             :destination_longitude,
             :id,
             :name

  has_one :creator, class_name: :user
  has_one :invite_code

  has_many :cars, serializer: SimpleCarSerializer
  has_many :signups

  def code
    self.invite_code.code
  end
end
