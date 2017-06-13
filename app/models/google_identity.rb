class GoogleIdentity < ApplicationRecord
  belongs_to :user

  validates :email, presence: true, uniqueness: true
  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: true
  validates :user, presence: true, uniqueness: true
end
