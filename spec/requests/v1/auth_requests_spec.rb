require "rails_helper"

RSpec.describe "Auth requests" do
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

        encoded_token = parsed_body["auth"]["access_token"]
        decoded_token = DecodeJwt.perform(encoded_token)
        expect(decoded_token["sub"]).to eq(parsed_body["auth"]["user"]["id"])
      end
    end
  end
end
