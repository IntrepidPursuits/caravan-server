require "rails_helper"

RSpec.describe "GoogleAuthenticator" do
  context "with only a token" do
    describe ".perform" do
      context "with invalid credentials" do
        it "should raise an error" do
          expect_any_instance_of(GoogleAuthenticator).to receive(:token_valid?).and_return(false)

          expect { GoogleAuthenticator.perform(token: "bah") }
            .to raise_error(UnauthorizedGoogleAccess)
        end
      end

      context "with valid credentials" do
        before(:each) do
          allow_any_instance_of(GoogleAuthenticator).to receive(:token_valid?).and_return(true)
          allow_any_instance_of(GoogleAuthenticator).to receive(:token_hash).and_return(user_info)
        end

        context "for an existing user and google_identity" do
          it "updates the existing user and GoogleIdentity" do
            create(:google_identity, uid: "383579238759")
            starting_user_count = User.count
            starting_google_id_count = GoogleIdentity.count

            user, google_identity = GoogleAuthenticator.perform(token: SecureRandom.hex(20))

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

            user, google_identity = GoogleAuthenticator.perform(token: SecureRandom.hex(20))

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

      context "with incomplete credentials" do
        before(:each) do
          allow_any_instance_of(GoogleAuthenticator).to receive(:token_valid?).and_return(false)
        end

        context "with missing required google identity information" do
          context "missing email" do
            it "raises an UnauthorizedGoogleAccess error" do
              allow_any_instance_of(GoogleAuthenticator)
                .to receive(:token_hash).and_return(user_info_missing_email)

              expect { GoogleAuthenticator.perform(
                token: SecureRandom.hex(20)
              ) }.to raise_error(UnauthorizedGoogleAccess)
            end
          end

          context "missing uid" do
            it "raises an UnauthorizedGoogleAccess error" do
              allow_any_instance_of(GoogleAuthenticator)
                .to receive(:token_hash).and_return(user_info_missing_uid)

              expect { GoogleAuthenticator.perform(
                token: SecureRandom.hex(20)
              ) }.to raise_error(UnauthorizedGoogleAccess)
            end
          end
        end

        context "with missing required user information" do
          context "missing name" do
            it "raises an UnauthorizedGoogleAccess error" do
              allow_any_instance_of(GoogleAuthenticator)
                .to receive(:token_hash).and_return(user_info_missing_name)

              expect { GoogleAuthenticator.perform(
                token: SecureRandom.hex(20)
              ) }.to raise_error(UnauthorizedGoogleAccess)
            end
          end
        end
      end
    end

    context "with all arguments provided" do
      let!(:args) {{
          token: SecureRandom.hex(20),
          name: "riki",
          image: "imageurl"
        }}

      describe ".perform" do
        context "with invalid credentials" do
          it "should raise an error" do
            expect_any_instance_of(GoogleAuthenticator).to receive(:token_valid?).and_return(false)

            expect { GoogleAuthenticator.perform(
              token: "bah",
              name: "a",
              image: "b"
              ) }.to raise_error(UnauthorizedGoogleAccess)
          end
        end

        context "with valid credentials" do
          before(:each) do
            allow_any_instance_of(GoogleAuthenticator).to receive(:token_valid?).and_return(true)
            allow_any_instance_of(GoogleAuthenticator).to receive(:token_hash).and_return(user_info_from_args)
          end

          context "for an existing user and google_identity" do
            it "updates the existing user and GoogleIdentity" do
              create(:google_identity, uid: "383579238759")
              starting_user_count = User.count
              starting_google_id_count = GoogleIdentity.count

              user, google_identity = GoogleAuthenticator.perform(args)

              expect(user).to be
              expect(google_identity).to be
              expect(User.count).to eq(starting_user_count)
              expect(GoogleIdentity.count).to eq(starting_google_id_count)
              expect(user.name).to eq("riki")
              expect(google_identity.uid).to eq("383579238759")
              expect(google_identity.email).to eq("rkonikoff@intrepid.io")
              expect(google_identity.image).to eq("imageurl")
            end
          end

          context "for a new user" do
            it "creates the new user and corresponding GoogleIdentity" do
              starting_user_count = User.count
              starting_google_id_count = GoogleIdentity.count

              user, google_identity = GoogleAuthenticator.perform(args)

              expect(user).to be
              expect(google_identity).to be
              expect(User.count).to be(starting_user_count + 1)
              expect(GoogleIdentity.count).to be(starting_google_id_count + 1)
              expect(user.name).to eq("riki")
              expect(google_identity.user_id).to eq(user.id)
              expect(google_identity.uid).to eq("383579238759")
              expect(google_identity.email).to eq("rkonikoff@intrepid.io")
              expect(google_identity.image).to eq("imageurl")
            end
          end
        end

        context "with incomplete credentials" do
          before(:each) do
            allow_any_instance_of(GoogleAuthenticator).to receive(:token_valid?).and_return(false)
          end

          context "with missing required google identity information" do
            context "missing email" do
              it "raises an UnauthorizedGoogleAccess error" do
                allow_any_instance_of(GoogleAuthenticator)
                  .to receive(:token_hash).and_return(user_info_missing_email)

                expect { GoogleAuthenticator.perform(args) }
                  .to raise_error(UnauthorizedGoogleAccess)
              end
            end

            context "missing uid" do
              it "raises an UnauthorizedGoogleAccess error" do
                allow_any_instance_of(GoogleAuthenticator)
                  .to receive(:token_hash).and_return(user_info_missing_uid)

                expect { GoogleAuthenticator.perform(args) }
                  .to raise_error(UnauthorizedGoogleAccess)
              end
            end
          end

          context "with missing required user information" do
            context "missing name" do
              it "raises an UnauthorizedGoogleAccess error" do
                allow_any_instance_of(GoogleAuthenticator)
                  .to receive(:token_hash).and_return(user_info_missing_name)

                expect { GoogleAuthenticator.perform(args) }
                  .to raise_error(UnauthorizedGoogleAccess)
              end
            end
          end
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

  def user_info_from_args
    {
      email: google_profile_info["email"],
      name: args[:name],
      google_uid: google_profile_info["sub"],
      image: args[:image]
    }
  end

  def user_info_missing_email
    {
      email: nil,
      name: google_profile_info["name"],
      google_uid: google_profile_info["sub"],
      image: google_profile_info["picture"]
    }
  end

  def user_info_missing_uid
    {
      email: google_profile_info["email"],
      name: google_profile_info["name"],
      google_uid: nil,
      image: google_profile_info["picture"]
    }
  end

  def user_info_missing_name
    {
      email: google_profile_info["email"],
      name: nil,
      google_uid: google_profile_info["sub"],
      image: nil
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
