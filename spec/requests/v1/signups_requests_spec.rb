require "rails_helper"

describe "Signup Request" do
  describe "POST /signups" do
    context "with valid trip, user, and signup code" do
      it "returns valid JSON for a new signup" do
        trip = create(:trip)
        unsaved_signup = build(:signup, trip: trip)
        valid_signup_info = {
          signup: unsaved_signup,
          invite_code: trip.invite_code.code
        }

        post(
          signups_url,
          params: valid_signup_info.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status :created
        expect(body).to have_json_path("signup")
        expect(body).to have_json_path("signup/user_id")
        expect(body).to have_json_path("signup/trip_id")
      end
    end

    context "with an invalid signup code" do
      it "returns JSON with error" do
        unsaved_signup_invalid_code = build(:signup)
        signup_info_invalid_code = {
          signup: unsaved_signup_invalid_code,
          invite_code: "abcdef"
        }

        post(
          signups_url,
          params: signup_info_invalid_code.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status :unprocessable_entity
        expect(body).to have_json_path("errors")
        expect(parsed_body["errors"]).to include ("Invalid invite code.")
      end
    end

    context "without a signup code" do
      it "returns JSON with error" do
        unsaved_signup_missing_code = build(:signup)
        signup_info_missing_code = {
          signup: unsaved_signup_missing_code
        }

        post(
          signups_url,
          params: signup_info_missing_code.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status :bad_request
        expect(body).to have_json_path("errors")
        expect(parsed_body["errors"]).to include ("Invite code is missing.")
      end
    end

    context "without a trip" do
      it "returns JSON with error" do
        unsaved_signup_missing_trip = build(:signup, trip: nil)
        signup_info_missing_trip = {
          signup: unsaved_signup_missing_trip,
          invite_code: "123456"
        }

        post(
          signups_url,
          params: signup_info_missing_trip.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status :unprocessable_entity
        expect(body).to have_json_path("errors")
        expect(parsed_body["errors"]).to include ("Validation failed")
        expect(parsed_body["errors"]).to include ("Trip must exist")
        expect(parsed_body["errors"]).to include ("Trip can't be blank")
      end
    end

    context "without a user" do
      it "returns JSON with error" do
        trip = create(:trip)
        unsaved_signup_missing_user = build(:signup, user: nil, trip: trip)
        signup_info_missing_user = {
          signup: unsaved_signup_missing_user,
          invite_code: trip.invite_code.code
        }

        post(
          signups_url,
          params: signup_info_missing_user.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status :unprocessable_entity
        expect(body).to have_json_path("errors")
        expect(parsed_body["errors"]).to include ("Validation failed")
        expect(parsed_body["errors"]).to include ("User must exist")
        expect(parsed_body["errors"]).to include ("User can't be blank")
      end
    end
  end
end
