require "rails_helper"

describe "Signup Request" do
  describe "POST /signups" do
    context "authenticated user" do
      let(:current_user) { create(:user) }

      context "with valid signup code for a valid trip" do
        it "returns valid JSON for a new signup" do
          trip = create(:trip)
          valid_signup_info = {
            invite_code: trip.invite_code.code
          }

          post(
            signups_url,
            params: valid_signup_info.to_json,
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :created
          expect(Signup.find_by(user: current_user, trip: trip)).to be
          expect_body_to_include_signup_attributes_and_content(current_user, trip)
        end
      end

      context "with an invalid signup code" do
        it "returns 422 Unprocessable Entity" do
          signup_info_invalid_code = {
            invite_code: "abcdef"
          }

          post(
            signups_url,
            params: signup_info_invalid_code.to_json,
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :unprocessable_entity
          expect(body).to have_json_path("errors")
          expect(errors).to eq("Invalid invite code. Please verify that you have the correct code.")
        end
      end

      context "with nil signup code" do
        it "returns 422 Unprocessable Entity" do
          signup_info_nil_code = {
            invite_code: nil
          }

          post(
            signups_url,
            params: signup_info_nil_code.to_json,
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :bad_request
          expect(body).to have_json_path("errors")
          expect(errors).to eq("Invite code is missing.")
        end
      end

      context "without a signup code" do
        it "returns 400 Bad Request" do
          post(
            signups_url,
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :bad_request
          expect(body).to have_json_path("errors")
          expect(errors).to eq("Invite code is missing.")
        end
      end

      context "invite code belongs to a deleted trip" do
        it "returns JSON with error" do
          trip = create(:trip)
          code = trip.invite_code.code
          trip.destroy

          signup_info_deleted_trip = {
            invite_code: code
          }

          post(
            signups_url,
            params: signup_info_deleted_trip.to_json,
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :unprocessable_entity
          expect(body).to have_json_path("errors")
          expect(errors).to eq("Validation failed: Trip must exist, Trip can't be blank")
        end
      end
    end

    context "unauthenticated user" do
      context "no authorization header" do
        it "returns 401 Unauthorized" do
          trip = create(:trip)
          valid_signup_info = {
            invite_code: trip.invite_code.code
          }

          post(
            signups_url,
            params: valid_signup_info.to_json,
            headers: accept_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end

      context "invalid access token" do
        it "returns 401 Unauthorized" do
          trip = create(:trip)
          valid_signup_info = {
            invite_code: trip.invite_code.code
          }

          post(
            signups_url,
            params: valid_signup_info.to_json,
            headers: invalid_authorization_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end
end
