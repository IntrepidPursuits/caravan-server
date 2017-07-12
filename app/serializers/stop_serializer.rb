class StopSerializer < BaseSerializer
  attributes :address,
             :description,
             :latitude,
             :longitude,
             :name,
             :trip_id
end
