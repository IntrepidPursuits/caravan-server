FactoryGirl.define do
  factory :car, aliases: [:owned_cars] do
    association :owner, factory: :user
    sequence(:name) { |n| "Car #{n}" }
    trip
  end
end
