class SimpleCarSerializer < ActiveModel::Serializer
  attributes :id,
    :max_seats,
    :name,
    :status
end
