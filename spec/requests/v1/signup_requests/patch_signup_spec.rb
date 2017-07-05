require "rails_helper"

describe "Signup Request" do
  describe "PATCH /signups/:id" do
    context "authenticated user" do
      let!(:current_user) { create(:user) }

      context "user tries to join a car" do
        context "with valid car_id and trip_id (for a trip the user is signed up for)" do
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

        context "user is signed up for a different car in the trip" do
          it "updates the signup from one car to the other" do
            google_identity = create(:google_identity, user: current_user)
            car = create(:car)
            trip = car.trip
            other_car = create(:car, trip: trip)
            signup = create(:signup, user: current_user, trip: trip, car: other_car)

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

        context "user is already signed up for the car" do
          it "does not attempt to update the signup" do
            google_identity = create(:google_identity, user: current_user)
            car = create(:car)
            signup = create(:signup, car: car, trip: car.trip, user: current_user)
            signup_params = { signup: signup }
            updated = signup.updated_at

            patch(
              api_v1_signup_url(signup),
              params: signup_params.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :ok
            expect(updated).to eq signup.updated_at
          end
        end

        context "in a trip the user is not signed up for" do
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
            expect(errors).to eq "Couldn't find Signup with 'id'=invalid signup"
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
            expect(errors).to eq "Couldn't find Car with 'id'=something invalid here"
          end
        end

        context "car exists but belongs to a different trip" do
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
            expect(errors).to eq "Cannot join a car that doesn't exist or that belongs to a different trip"
          end
        end

        context "someone else's signup" do
          it "returns 403 Forbidden" do
            signup = create(:signup)
            unsaved_signup = build(:signup, user: current_user, trip: signup.trip)
            signup_params = { signup: unsaved_signup }

            patch(
              api_v1_signup_url(signup),
              params: signup_params.to_json,
              headers: authorization_headers(current_user)
            )

            expect_user_forbidden_response
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
