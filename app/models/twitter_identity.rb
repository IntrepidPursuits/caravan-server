class TwitterIdentity < ApplicationRecord
  belongs_to :user

  validates_presence_of :provider, :twitter_id, :user
  validates_uniqueness_of :twitter_id, :user
end
