require "rails_helper"

RSpec.describe "GoogleAuthenticator" do
  describe ".perform" do
    context "with invalid credentials" do
      it "should raise an error" do
        GoogleAuthenticator.any_instance.stub(:token_valid?).and_return(false)

        expect { GoogleAuthenticator.perform("bah") }.to raise_error(Api::V1::ApiController::UnauthorizedAccess)
      end
    end

    context "with valid credentials" do
      before(:each) do
        GoogleAuthenticator.any_instance.stub(:token_valid?).and_return(true)
        GoogleAuthenticator.any_instance.stub(:token_hash).and_return(user_info)
      end

      context "for an existing user and google_identity" do
        it "updates the existing user and GoogleIdentity" do
          create(:google_identity, uid: "383579238759")
          starting_user_count = User.count
          starting_google_id_count = GoogleIdentity.count

          user, google_identity = GoogleAuthenticator.perform(SecureRandom.hex(20))

          expect(user).to be
          expect(google_identity).to be
          expect(User.count).to eq(starting_user_count)
          expect(GoogleIdentity.count).to eq(starting_google_id_count)
          expect(user.name).to eq("Riki Konikoff")
          expect(google_identity.uid).to eq("383579238759")
          expect(google_identity.email).to eq("rkonikoff@intrepid.io")
          expect(google_identity.image).to eq("https://somepicture.jpg")
        end
      end

      context "for a new user" do
        it "creates the new user and corresponding GoogleIdentity" do
          starting_user_count = User.count
          starting_google_id_count = GoogleIdentity.count

          user, google_identity = GoogleAuthenticator.perform(SecureRandom.hex(20))

          expect(user).to be
          expect(google_identity).to be
          expect(User.count).to be(starting_user_count + 1)
          expect(GoogleIdentity.count).to be(starting_google_id_count + 1)
          expect(user.name).to eq("Riki Konikoff")
          expect(google_identity.user_id).to eq(user.id)
          expect(google_identity.uid).to eq("383579238759")
          expect(google_identity.email).to eq("rkonikoff@intrepid.io")
          expect(google_identity.image).to eq("https://somepicture.jpg")
        end
      end
    end
  end

  def user_info
    {
      email: google_profile_info["email"],
      name: google_profile_info["name"],
      google_uid: google_profile_info["sub"],
      image: google_profile_info["picture"]
    }
  end

  def google_profile_info
    JSON.parse load_fixture("google_info_response.json")
  end

  def google_uid
    token_hash = JSON.parse load_fixture("unverified_token_object.json")
    token_hash["sub"]
  end
end
