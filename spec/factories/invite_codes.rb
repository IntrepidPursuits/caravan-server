FactoryGirl.define do
  factory :invite_code do
    sequence(:code) { |n| "sdfsdfd #{n}" } 
  end
end
