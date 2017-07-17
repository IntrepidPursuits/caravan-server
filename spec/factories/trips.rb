FactoryGirl.define do
  factory :trip, aliases: [:created_trips] do
    association :creator, factory: :user
    name "Ski Trip"
    departing_on "2020/7/18"
    destination_latitude 1.000000
    destination_longitude 1.000000
    destination_address "1 Sesame St"
    invite_code
  end
end
