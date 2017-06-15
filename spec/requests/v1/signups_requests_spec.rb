require "rails_helper"

describe "Signup Request" do
  describe "POST /signups" do
    context "with valid trip and user" do
      it "returns valid JSON for a new signup" do
        unsaved_signup = build(:signup)
        valid_signup_info = { signup: unsaved_signup }

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

    context "without a trip" do
      it "returns an Unprocessable Entity error" do
        unsaved_signup_missing_trip = build(:signup, trip: nil)
        signup_info_missing_trip = { signup: unsaved_signup_missing_trip }

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
      it "returns an Unprocessable Entity error" do
        unsaved_signup_missing_user = build(:signup, user: nil)
        signup_info_missing_user = { signup: unsaved_signup_missing_user }

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
