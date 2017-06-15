class SignupSerializer < ActiveModel::Serializer
  attributes :created_at, :id, :trip_id, :updated_at, :user_id
end
