class InviteCode < ApplicationRecord
  has_one :trip

  validates :code, presence: true, uniqueness: true
end
