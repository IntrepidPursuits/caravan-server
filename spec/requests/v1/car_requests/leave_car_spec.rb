require "rails_helper"

describe "LeaveCar Request" do
  describe "PATCH /cars/:car_id/leave" do
    context "authenticated user" do
      let!(:current_user) { create(:user) }
      let!(:google_identity) { create(:google_identity, user: current_user) }

      context "user is signed up for a car in a trip" do
        it "removes the user from the car & returns 204 No Content" do
          car = create(:car)
          signup = create(:signup, trip: car.trip, car: car, user: current_user)
          expect(car.users).to include(current_user)

          patch(
            api_v1_car_leave_url(car),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :no_content

          car.reload
          expect(car.users).to_not include(current_user)
          signup.reload
          expect(signup.car_id).to eq nil
        end
      end

      context "user is the car's owner, and is signed up for the trip & car" do
        it "deletes the car and updates all relevant signups" do
          # add commented lines when more than one user can be in a car
          car = create(:car, owner: current_user)
          trip = car.trip
          signup = create(:signup, trip: trip, car: car, user: current_user)
          # signup_2 = create(:signup, trip: trip, car: car)

          expect(car.owner).to eq(current_user)
          expect(car.users).to include(current_user)
          # expect(car.users.length).to eq 2

          patch(
            api_v1_car_leave_url(car),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :no_content
          expect{ Car.find(car.id) }.to raise_error(ActiveRecord::RecordNotFound)
          signup.reload
          # signup_2.reload

          expect(signup.car).to eq nil
          # expect(signup_2.car).to eq nil
        end
      end

      context "invalid signup" do
        context "user is not signed up for the trip or the car" do
          it "returns 403 Forbidden" do
            car = create(:car)

            patch(
            api_v1_car_leave_url(car),
            headers: authorization_headers(current_user)
            )

            expect_user_forbidden_response
          end
        end

        context "user is signed up for the trip, but not the car" do
          it "returns 403 Forbidden" do
            trip = create(:trip)
            car = create(:car, trip: trip)
            signup = create(:signup, trip: trip, user: current_user)

            patch(
              api_v1_car_leave_url(car),
              headers: authorization_headers(current_user)
            )

            expect_user_forbidden_response
          end
        end

        context "user is signed up for the car, but not the trip" do
          it "returns 422 Unprocessable Entity" do
            trip = create(:trip)
            car = create(:car, trip: trip)
            signup = create(:signup, car: car, user: current_user)

            patch(
              api_v1_car_leave_url(car),
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :unprocessable_entity
            expect(errors).to eq(
              "Unable to leave car; it doesn't exist or user is not signed up properly.")
          end
        end
      end

      context "invalid car_id" do
        it "returns 404 Not Found" do
          patch(
            api_v1_car_leave_url("gobbledegook"),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :not_found
          expect(errors).to eq "Couldn't find Car with 'id'=gobbledegook"
        end
      end

      context "user is signed up for the car, but it exists on a different trip" do
        it "returns 422 Unprocessable Entity" do
          car = create(:car)
          signup = create(:signup, car: car, user: current_user)

          patch(
            api_v1_car_leave_url(car),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :unprocessable_entity
          expect(errors).to eq(
            "Unable to leave car; it doesn't exist or user is not signed up properly.")
        end
      end
    end

    context "unauthenticated user" do
      context "no authorization header" do
        it "returns 401 Unauthorized" do
          car = create(:car)
          signup = create(:signup, trip: car.trip, car: car)

          patch(
            api_v1_car_leave_url(car),
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
            api_v1_car_leave_url(car),
            headers: invalid_authorization_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end
end
