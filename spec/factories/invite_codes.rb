FactoryGirl.define do
  factory :invite_code do
    sequence(:code) { |n| "12345#{n}" } 
  end
end
