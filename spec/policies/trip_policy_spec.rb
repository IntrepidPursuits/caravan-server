require "rails_helper"

describe "TripPolicy" do
  let(:user) { create(:user) }
  let(:trip) { create(:trip) }

  permissions :create_car? do
    it "grants access if the user is signed up for the trip" do
      create(:signup, trip: trip, user: user)
      expect(TripPolicy).to permit(user, trip)
    end

    it "denies access if the user is not signed up for the trip" do
      expect(TripPolicy).not_to permit(user, trip)
    end
  end
end
