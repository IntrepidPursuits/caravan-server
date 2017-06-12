class TripSerializer < ActiveModel::Serializer
  attributes :id,
    :departing_on,
    :destination_address,
    :destination_latitude,
    :destination_longitude,
    :invite_code,
    :name,
    :created_at,
    :updated_at,
    :creator,
    :cars,
    :signups
end
