require "rails_helper"

RSpec.describe Trip, type: :model do
  describe "associations" do
    it { should belong_to(:creator) }
    it { should have_many(:cars) }
    it { should have_many(:users).through(:user_trips) }
    it { should have_many(:user_trips) }
  end

  describe "validations" do
    it { should validate_presence_of(:creator_id) }
    it { should validate_presence_of(:departure_date) }
    it { should validate_presence_of(:destination_address) }
    it { should validate_presence_of(:destination_latitude) }
    it { should validate_presence_of(:destination_longitude) }
    it { should validate_presence_of(:invite_code) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
