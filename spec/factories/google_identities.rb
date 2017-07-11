FactoryGirl.define do
  factory :google_identity do
    user
    uid { SecureRandom.hex(10) }
    sequence(:email) { |n| "#{n}@example.com" }
    image "googlepic"
  end
end
