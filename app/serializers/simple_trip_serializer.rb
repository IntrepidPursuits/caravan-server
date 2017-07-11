class SimpleTripSerializer < BaseSerializer
  attributes :code,
             :creator,
             :departing_on,
             :destination_address,
             :destination_latitude,
             :destination_longitude,
             :name

  has_one :creator, class_name: :user
  has_one :invite_code

  def code
    self.invite_code.code
  end
end
