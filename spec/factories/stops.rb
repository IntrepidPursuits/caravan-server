FactoryGirl.define do
  factory :stop do
    sequence(:address) { |n| "150 First St #{n}" }
    sequence(:name) { |a| "My Stop #{a}" }
    latitude 71.304
    longitude 53.46
    trip
  end
end
