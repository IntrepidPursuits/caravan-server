class TripSerializer < ActiveModel::Serializer
  attributes :cars,
             :code,
             :created_at,
             :creator,
             :departing_on,
             :destination_address,
             :destination_latitude,
             :destination_longitude,
             :id,
             :name,
             :signed_up_users,
             :updated_at

  has_one :creator
  has_one :invite_code

  has_many :cars
  has_many :signups
  has_many :users, through: :signups

  def code
    self.invite_code.code
  end

  def signed_up_users
    self.users
  end
end
