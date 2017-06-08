FactoryGirl.define do
  factory :seat do
    car
    user
    driver? true
  end
end
