require "rails_helper"

RSpec.describe "Auth requests" do
  describe "POST /auth" do
    context "with valid google token for a new user" do
      before :each do
        stub_google_token_request
        stub_google_info_request
      end

      it "returns a valid JSON user data" do
        google_identity = build(:google_identity)
        params = { auth: { token: google_identity.token } }

        post(
          auths_url,
          params: params.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status :created
        expect(body).to have_json_path("user")
        expect(body).to have_json_path("user/id")
        expect(body).to have_json_path("user/name")
        expect(body).to have_json_path("user/google_identity")
        expect(body).to have_json_path("user/google_identity/id")
        expect(body).to have_json_path("user/google_identity/email")
        expect(body).to have_json_path("user/google_identity/token")
        expect(body).to have_json_path("user/google_identity/token_expires_at")
        expect(body).to have_json_path("user/google_identity/uid")
        expect(body).to have_json_path("user/google_identity/user_id")
      end

      it "creates a new GoogleIdentity and corresponding User" do
        google_identity = build(:google_identity)
        params = { auth: { token: google_identity.token } }
        g_ids_count = GoogleIdentity.count
        users_count = User.count

        post(
          auths_url,
          params: params.to_json,
          headers: accept_headers
        )

        expect(google_identity).to be
        expect(GoogleIdentity.count).to be(g_ids_count + 1)
        expect(User.count).to be(users_count + 1)
      end
    end
  end

  def auth_params
    { token: SecureRandom.hex(20) }
  end
end
