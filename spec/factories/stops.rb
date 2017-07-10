FactoryGirl.define do
  factory :stop do
    trip
    name "My Stop"
    address "150 First St"
    latitude 71.304
    longitude 53.46
  end
end
