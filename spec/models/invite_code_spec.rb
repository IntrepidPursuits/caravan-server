require "rails_helper"

RSpec.describe InviteCode, type: :model do
  describe "associations" do
    it { should have_one(:trip) }
  end

  describe "validations" do
    it { should validate_presence_of(:code) }
    it do
      create(:invite_code)
      should validate_uniqueness_of(:code).case_insensitive
    end
  end
end
