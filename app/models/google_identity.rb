class GoogleIdentity < ApplicationRecord
  belongs_to :user

  validates_presence_of :email, :provider, :uid, :user
  validates_uniqueness_of :email, :uid, :user
end
