require "rails_helper"

describe "FindASignup" do
  context "unauthorized user" do
    it "raises UserNotAuthorizedError" do
      signup = create(:signup)
      current_user = create(:user)

      expect { FindASignup.perform(signup.trip, current_user) }.to raise_error UserNotAuthorizedError
    end
  end

  context "authorized user" do
    it "returns a signup" do
      signup = create(:signup)
      value = FindASignup.perform(signup.trip, signup.user)
      expect(value).to eq(signup)
    end
  end
end
