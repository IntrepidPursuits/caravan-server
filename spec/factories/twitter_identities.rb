FactoryGirl.define do
  factory :twitter_identity do
    provider "twitter"
    twitter_id { SecureRandom.hex(10) }
    user
    image "twitterpic"
  end
end
