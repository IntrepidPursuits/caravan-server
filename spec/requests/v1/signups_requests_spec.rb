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
    context "authenticated user" do
      let!(:current_user) { create(:user) }

      context "user joins a car" do
        context "with valid car_id and a trip the user is signed up for" do
          it "returns valid JSON for the updated car and passengers" do
            google_identity = create(:google_identity, user: current_user)
            car = create(:car)
            trip = car.trip
            signup = create(:signup, user: current_user, trip: trip)

            signup_params = { signup: {
              trip_id: signup.trip_id,
              car_id: car.id
            } }

            patch(
              api_v1_signup_url(signup),
              params: signup_params.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :ok
            expect_body_to_include_car_attributes(car, trip, current_user)
          end
        end

        context "user is not signed up for the trip" do
          it "returns 404 Not Found" do
            car = create(:car)
            trip = car.trip

            signup_params = { signup: {
              trip_id: trip.id,
              car_id: car.id
            } }

            patch(
              api_v1_signup_url("invalid signup"),
              params: signup_params.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :not_found
          end
        end

        context "with a car that belongs to a different trip" do
          it "returns 422 Unprocessable Entity" do
            car = create(:car)
            create(:google_identity, user: current_user)
            signup = create(:signup, user: current_user)

            signup_params = { signup: {
              trip_id: signup.trip_id,
              car_id: car.id
            } }

            patch(
              api_v1_signup_url(signup),
              params: signup_params.to_json,
              headers: authorization_headers(current_user)
            )
            
            expect(response).to have_http_status :unprocessable_entity
          end
        end

        context "someone else's signup" do
          it "raises 403 Forbidden" do
            signup = create(:signup)
            unsaved_signup = build(:signup, user: current_user)
            signup_params = { signup: unsaved_signup }

            patch(
            api_v1_signup_url(signup),
            params: signup_params.to_json,
            headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :forbidden
          end
        end

        context "car does not exist" do
          it "returns 404 Not Found" do
            trip = create(:trip)
            signup = create(:signup, trip: trip, user: current_user)

            signup_params = { signup: {
              trip_id: trip.id,
              car_id: "something invalid here"
            } }

            patch(
              api_v1_signup_url(signup),
              params: signup_params.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :not_found
          end
        end
      end

      context "unauthorized user" do
        context "no authorization header" do
          it "returns 401 Unauthorized" do
            car = create(:car)
            signup = create(:signup, trip: car.trip, car: car)

            signup_params = { signup: {
              trip_id: car.trip_id,
              car_id: car.id
            } }

            patch(
              api_v1_signup_url(signup),
              params: signup_params.to_json,
              headers: accept_headers
            )

            expect(response).to have_http_status :unauthorized
          end
        end

        context "invalid access token" do
          it "returns 401 Unauthorized" do
            car = create(:car)
            signup = create(:signup, trip: car.trip, car: car)

            signup_params = { signup: {
              trip_id: car.trip_id,
              car_id: car.id
            } }

            patch(
              api_v1_signup_url(signup),
              params: signup_params.to_json,
              headers: invalid_authorization_headers
            )

            expect(response).to have_http_status :unauthorized
          end
        end
      end
    end
  end
end
