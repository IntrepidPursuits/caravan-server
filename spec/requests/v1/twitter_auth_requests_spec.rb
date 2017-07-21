require "rails_helper"

describe "Twitter Auths requests" do
  describe "POST /auths/twitter" do
    context "with valid token and token secret for new user" do
      it "returns valid JSON auth and user data" do
        stub_twitter_token_request
        user_count = User.count
        twitter_identity_count = TwitterIdentity.count
        google_identity_count = GoogleIdentity.count

        params = { auth: { token: SecureRandom.hex(20), token_secret: SecureRandom.hex(20) } }

        post(
          twitter_url,
          params: params.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status(:created)
        expect(User.count).to eq(user_count + 1)
        expect(TwitterIdentity.count).to eq(twitter_identity_count + 1)
        expect(GoogleIdentity.count).to eq(google_identity_count)
        expect(body).to have_json_path("auth")
        expect(body).to have_json_path("auth/access_token")
        expect(body).to have_json_path("auth/user")
        expect(body).to have_json_path("auth/user/id")
        expect(body).to have_json_path("auth/user/name")
        expect(body).to have_json_path("auth/user/google_identity")
        expect(body).to have_json_path("auth/user/twitter_identity")
        expect(body).to have_json_path("auth/user/twitter_identity/id")
        expect(body).to have_json_path("auth/user/twitter_identity/image")
        expect(body).to have_json_path("auth/user/twitter_identity/screen_name")
        expect(body).to have_json_path("auth/user/twitter_identity/twitter_id")
        expect(json_value_at_path("auth/user/name")).to eq("Marjie Lam")
        expect(json_value_at_path("auth/user/google_identity")).to eq(nil)
        expect(json_value_at_path("auth/user/twitter_identity/image")).to eq("http://abs.twimg.com/sticky/default_profile_images/default_profile_normal.png")
        expect(json_value_at_path("auth/user/twitter_identity/screen_name")).to eq("lam_marjie")
        expect(json_value_at_path("auth/user/twitter_identity/twitter_id")).to eq("883389619680804864")
      end
    end

    context "missing token" do
      it "returns Unprocessable Entity error" do
        stub_invalid_twitter_token_request
        user_count = User.count
        twitter_identity_count = TwitterIdentity.count
        google_identity_count = GoogleIdentity.count

        params = { auth: { token_secret: SecureRandom.hex(20) } }

        post(
          twitter_url,
          params: params.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status(:unprocessable_entity)
        expect(errors).to include("Invalid token: Check that you have the correct token and token secret.")
        expect(User.count).to eq(user_count)
        expect(TwitterIdentity.count).to eq(twitter_identity_count)
        expect(GoogleIdentity.count).to eq(google_identity_count)
      end
    end

    context "missing token secret" do
      it "returns Unprocessable Entity error" do
        stub_invalid_twitter_token_request
        user_count = User.count
        twitter_identity_count = TwitterIdentity.count
        google_identity_count = GoogleIdentity.count

        params = { auth: { token: SecureRandom.hex(20) } }

        post(
          twitter_url,
          params: params.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status(:unprocessable_entity)
        expect(errors).to include("Invalid token: Check that you have the correct token and token secret.")
        expect(User.count).to eq(user_count)
        expect(TwitterIdentity.count).to eq(twitter_identity_count)
        expect(GoogleIdentity.count).to eq(google_identity_count)
      end
    end

    context "invalid token or token secret" do
      it "returns Unprocessable Entity error" do
        stub_invalid_twitter_token_request
        user_count = User.count
        twitter_identity_count = TwitterIdentity.count
        google_identity_count = GoogleIdentity.count

        params = { auth: { token: SecureRandom.hex(20), token_secret: SecureRandom.hex(20) } }

        post(
          twitter_url,
          params: params.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status(:unprocessable_entity)
        expect(errors).to include("Invalid token: Check that you have the correct token and token secret.")
        expect(User.count).to eq(user_count)
        expect(TwitterIdentity.count).to eq(twitter_identity_count)
        expect(GoogleIdentity.count).to eq(google_identity_count)
      end
    end
  end
end
