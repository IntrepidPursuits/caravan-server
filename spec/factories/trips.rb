FactoryGirl.define do
  factory :trip, aliases: [:created_trips] do
    association :creator, factory: :user
    name "Ski Trip"
    departing_on DateTime.now.beginning_of_day
    destination_latitude "42.3662828"
    destination_longitude "-71.0799026"
    destination_address "1 Sesame St"
    invite_code
  end
end
