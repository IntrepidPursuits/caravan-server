require "rails_helper"

RSpec.describe UserTrip, type: :model do
  describe "associations" do
    it { should belong_to(:trip) }
    it { should belong_to(:user) }
  end

  describe "validations" do
    it do
      create(:user_trip)
      should validate_uniqueness_of(:user).scoped_to(:trip_id)
    end
  end
end
