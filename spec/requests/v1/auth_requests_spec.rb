require "rails_helper"

describe "Auth requests" do
  describe "POST /auths" do
    context "with valid google token for a new user" do
      before :each do
        stub_google_token_request
      end

      it "returns valid JSON auth and user data" do
        params = { auth: { token: SecureRandom.hex(20) } }

        post(
          auths_url,
          params: params.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status :created
        expect(body).to have_json_path("auth")
        expect(body).to have_json_path("auth/access_token")
        expect(body).to have_json_path("auth/user")
        expect(body).to have_json_path("auth/user/id")
        expect(body).to have_json_path("auth/user/name")
        expect(body).to have_json_path("auth/user/google_identity")
        expect(body).to have_json_path("auth/user/google_identity/id")
        expect(body).to have_json_path("auth/user/google_identity/email")
        expect(body).to have_json_path("auth/user/google_identity/uid")
        expect(body).to have_json_path("auth/user/google_identity/user_id")
      end

      it "creates a decryptable token" do
        params = { auth: { token: SecureRandom.hex(20) } }

        post(
          auths_url,
          params: params.to_json,
          headers: accept_headers
        )

        encoded_token = json_value_at_path("auth/access_token")
        decoded_token = HandleJwt.decode(encoded_token)
        expect(decoded_token["sub"]).to eq(json_value_at_path("auth/user/id"))
      end
    end

    context "with google token from an invalid client" do
      it "raises an error" do
        stub_invalid_client_id_request
        params = { auth: { token: SecureRandom.hex(20) } }

        post(
          auths_url,
          params: params.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status :unprocessable_entity
        expect(errors).to eq invalid_token_message
      end
    end

    context "with google token without enough scope to get all required info to
      create google identity" do
      context "missing email" do
        it "does not create User or GoogleIdentity and returns JSON with error" do
          stub_missing_email_request
          params = { auth: { token: SecureRandom.hex(20) } }
          user_count = User.count
          google_identity_count = GoogleIdentity.count

          post(
            auths_url,
            params: params.to_json,
            headers: accept_headers
          )

          expect(User.count).to eq user_count
          expect(GoogleIdentity.count).to eq google_identity_count
          expect(response).to have_http_status :unprocessable_entity
          expect(errors).to eq invalid_token_message
        end
      end

      context "missing uid" do
        it "does not create User or GoogleIdentity and returns JSON with error" do
          stub_missing_uid_request
          params = { auth: { token: SecureRandom.hex(20) } }
          user_count = User.count
          google_identity_count = GoogleIdentity.count

          post(
            auths_url,
            params: params.to_json,
            headers: accept_headers
          )

          expect(User.count).to eq user_count
          expect(GoogleIdentity.count).to eq google_identity_count
          expect(response).to have_http_status :unprocessable_entity
          expect(errors).to eq invalid_token_message
        end
      end
    end

    context "with google token without enough scope to get all required info to
      create user" do
      context "missing name" do
        it "does not create User or GoogleIdentity and returns JSON with error" do
          stub_missing_name_request
          params = { auth: { token: SecureRandom.hex(20) } }
          user_count = User.count
          google_identity_count = GoogleIdentity.count

          post(
            auths_url,
            params: params.to_json,
            headers: accept_headers
          )

          expect(User.count).to eq user_count
          expect(GoogleIdentity.count).to eq google_identity_count
          expect(response).to have_http_status :unprocessable_entity
          expect(errors).to eq invalid_token_message
        end
      end
    end
  end
end

def invalid_token_message
  "Invalid token: Check that you have the correct client ID, all required permissions, and that your token has not expired."
end
