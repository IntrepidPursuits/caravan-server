require "rails_helper"

RSpec.describe "GoogleAuthenticator" do
  describe ".perform" do
    context "with invalid credentials" do
      it "should raise an error" do
        token_validator = double("token_validator")
        allow(token_validator).to receive(:perform).and_return(false)
        expect { GoogleAuthenticator.perform("a") }.to raise_error(Api::V1::ApiController::UnauthorizedAccess)
      end
    end

    context "with valid credentials" do
      before(:each) do
        token_validator = double("token_validator")
        allow(token_validator).to receive(:perform).and_return(true)

        google_profile = double("google_profile")
        allow(google_profile).to receive(:perform).and_return(google_info_response)
      end

      context "for an existing user and google_identity" do
        it "logs in the user" do

        end
      end

      context "for a new user" do
        it "creates the new user" do
          token = SecureRandom.hex(20)
          starting_count = User.count
          authenticated_object = GoogleAuthenticator.perform(token)
          user = authenticated_object[0]

          expect(user).to be
          expect(User.count).to be(starting_count + 1)
          expect(user.name).to be
        end

        it "creates a new google_identity for the new user" do
          token = SecureRandom.hex(20)
          user, google_identity = GoogleAuthenticator.perform(token)

          expect(google_identity.user_id).to eq(user.id)
          expect(google_identity.token).to eq(token)
          expect(google_identity.uid).to be
          expect(google_identity.email).to be
        end
      end
    end
  end

  def google_uid
    token_hash = JSON.parse load_fixture("unverified_token_object.json")
    token_hash["sub"]
  end
end
