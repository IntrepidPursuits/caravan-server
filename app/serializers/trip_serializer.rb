class TripSerializer < ActiveModel::Serializer
  attributes :cars,
             :created_at,
             :creator,
             :departing_on,
             :destination_address,
             :destination_latitude,
             :destination_longitude,
             :id,
             :invite_code,
             :name,
             :updated_at,
             :users
end
