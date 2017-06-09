FactoryGirl.define do
  factory :user, aliases: [:creator] do
    association :created_trips, factory: :trip
    name "Nancy"
  end
end
