require "rails_helper"

RSpec.describe Trip, type: :model do
  describe "associations" do
    it { should belong_to(:creator) }
    it { should have_many(:cars) }
    it { should have_many(:signups) }
    it { should have_many(:users).through(:signups) }
  end

  describe "validations" do
    it { should validate_presence_of(:creator) }
    it { should validate_presence_of(:departing_on) }
    it { should validate_presence_of(:destination_address) }
    it { should validate_presence_of(:destination_latitude) }
    it { should validate_presence_of(:destination_longitude) }
    it { should validate_presence_of(:invite_code) }
    it { should validate_presence_of(:name) }
    it do
      user = create(:user)
      create(:trip, creator: user)
      should validate_uniqueness_of(:name)
    end
  end
end
