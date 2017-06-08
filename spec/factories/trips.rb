FactoryGirl.define do
  factory :trip do
    association :creator, factory: :user
    sequence(:name) { |n| "Ski Trip #{n}" }
    departure_date Date.new
    destination_latitude 1.000000
    destination_longitude 1.000000
    destination_address "1 Sesame St"
    invite_code "sdfsdfd"
  end
end
