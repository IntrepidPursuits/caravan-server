FactoryGirl.define do
  factory :car do
    sequence(:name) { |n| "Car #{n}" } 
    trip
  end
end
