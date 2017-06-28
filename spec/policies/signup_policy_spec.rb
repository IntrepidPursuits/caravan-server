require "rails_helper"

describe SignupPolicy do
  let!(:user) { create(:user) }
  let!(:car) { create(:car) }

  permissions :update? do
    it "grants access if signup.user matches the current user" do
      signup = create(:signup, trip: car.trip, user: user)
      expect(SignupPolicy).to permit(user, signup)
    end

    it "denies access if signup.user is not the current user" do
      signup = create(:signup, trip: car.trip)
      expect(SignupPolicy).not_to permit(user, signup)
    end
  end
end
