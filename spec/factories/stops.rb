FactoryGirl.define do
  factory :stop do
    trip
    sequence(:name) { |a| "My Stop #{a}" }
    sequence(:address) { |n| "150 First St #{n}" }
    latitude 71.304
    longitude 53.46
  end
end
