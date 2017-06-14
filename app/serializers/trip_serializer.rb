class TripSerializer < ActiveModel::Serializer
  attributes :cars,
             :created_at,
             :creator,
             :id,
             :departing_on,
             :destination_address,
             :destination_latitude,
             :destination_longitude,
             :invite_code,
             :name,
             :updated_at,
             :users
end
