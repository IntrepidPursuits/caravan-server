require "rails_helper"

describe "Signup Request" do
  describe "POST /signups" do
    context "authenticated user" do
      let(:current_user) { create(:user) }

      context "with valid trip and signup code" do
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
            headers: authorization_headers(current_user)
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
            headers: authorization_headers(current_user)
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
            headers: authorization_headers(current_user)
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
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :unprocessable_entity
          expect(body).to have_json_path("errors")
          expect(parsed_body["errors"]).to include ("Validation failed")
          expect(parsed_body["errors"]).to include ("Trip must exist")
          expect(parsed_body["errors"]).to include ("Trip can't be blank")
        end
      end
    end

    context "unauthenticated user" do
      context "no authorization header" do
        it "returns 401 Unauthorized" do
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

          expect(response).to have_http_status :unauthorized
        end
      end

      context "invalid access token" do
        it "returns 401 Unauthorized" do
          trip = create(:trip)
          unsaved_signup = build(:signup, trip: trip)
          valid_signup_info = {
            signup: unsaved_signup,
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

  describe "PATCH /signups/:id" do
    context "when a user signs up for a car" do
      context "for an existing trip, user, and car" do
        it "returns valid JSON for the updated car and passengers" do
          trip = create(:trip)
          google_identity = create(:google_identity)
          current_user = create(:user, google_identity: google_identity)
          car = create(:car, trip: trip)
          signup = create(:signup, user: current_user, trip: trip)

          signup_params = { signup: {
            user_id: current_user.id,
            trip_id: trip.id,
            car_id: car.id
          } }

          patch(
            api_v1_signup_url(signup),
            params: signup_params.to_json,
            headers: accept_headers
          )

          expect(response).to have_http_status :ok
          expect(parsed_body["car"]["id"]).to eq car.id
          expect(parsed_body["car"]["locations"]).to eq []
          expect(parsed_body["car"]["max_seats"]).to eq car.max_seats
          expect(parsed_body["car"]["name"]).to eq car.name
          expect(parsed_body["car"]["status"]).to eq trip.status
          expect(parsed_body["car"]["trip"]["id"]).to eq trip.id
          expect(parsed_body["car"]["trip"]["name"]).to eq trip.name
          expect(parsed_body["car"]["passengers"][0]["id"]).to eq current_user.id
          expect(parsed_body["car"]["passengers"][0]["name"]).to eq current_user.name
          expect(parsed_body["car"]["passengers"][0]["email"]).to eq google_identity.email
        end
      end
    end
  end
end
