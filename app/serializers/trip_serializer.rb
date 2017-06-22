class TripSerializer < BaseSerializer
  attributes :cars,
             :code,
             :creator,
             :departing_on,
             :destination_address,
             :destination_latitude,
             :destination_longitude,
             :name,
             :signed_up_users

  has_one :creator
  has_one :invite_code

  has_many :cars, serializer: SimpleCarSerializer
  has_many :signups
  has_many :users, through: :signups

  def code
    self.invite_code.code
  end

  def signed_up_users
    self.users
  end
end
