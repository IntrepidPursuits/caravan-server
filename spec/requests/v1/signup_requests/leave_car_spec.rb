require "rails_helper"

describe "LeaveCar Request" do
  describe "PATCH /signups/:signup_id/leave" do
    context "authenticated user" do
      let!(:current_user) { create(:user) }
      let!(:google_identity) { create(:google_identity, user: current_user) }

      context "user is signed up for a car in a trip" do
        it "removes the user from the car" do
          car = create(:car)
          signup = create(:signup, trip: car.trip, car: car, user: current_user)
          expect(car.users).to include(current_user)

          patch(
            api_v1_signup_leave_url(signup),
            headers: authorization_headers(current_user)
          )

          updated_car = Car.find(car.id)
          expect(updated_car.users).to_not include(current_user)
          updated_signup = Signup.find(signup.id)
          expect(updated_signup.car_id).to eq nil
        end

        it "returns updated JSON for the car" do
          car = create(:car)
          signup = create(:signup, trip: car.trip, car: car, user: current_user)

          patch(
            api_v1_signup_leave_url(signup),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :ok
          updated_car = Car.find(car.id)
          expect_body_to_include_car_attributes_without_user(updated_car, updated_car.trip, current_user)
        end
      end

      context "signup does not include a car_id" do
        context "user is signed up for the trip, just not the car" do
          it "returns 400 Bad Request" do
            trip = create(:trip)
            signup = create(:signup, trip: trip, user: current_user)

            patch(
              api_v1_signup_leave_url(signup),
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :bad_request
          end
        end

        context "user is not signed up for the trip" do
          it "returns 400 Bad Request" do
            signup = create(:signup)

            patch(
              api_v1_signup_leave_url(signup),
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :bad_request
          end
        end
      end

      context "signup belongs to a different user" do
        it "returns 403 Forbidden" do
          car = create(:car)
          signup = create(:signup, trip: car.trip, car: car)

          patch(
            api_v1_signup_leave_url(signup),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :forbidden
        end
      end
    end

    context "unauthenticated user" do
      context "no authorization header" do
        it "returns 401 Unauthorized" do
          car = create(:car)
          signup = create(:signup, trip: car.trip, car: car)

          patch(
            api_v1_signup_leave_url(signup),
            headers: accept_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end

      context "invalid auth token" do
        it "returns 401 Unauthorized" do
          car = create(:car)
          signup = create(:signup, trip: car.trip, car: car)

          patch(
            api_v1_signup_leave_url(signup),
            headers: invalid_authorization_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end
end
