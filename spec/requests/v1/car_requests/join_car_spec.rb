require "rails_helper"

describe "Join Car Request" do
  describe "PATCH /cars/:car_id/join" do
    context "authenticated user" do
      let!(:current_user) { create(:user) }
      let!(:google_identity) { create(:google_identity, user: current_user) }

      context "user is signed up for the car's trip and no other car" do
        context "there is space in the car" do
          it "returns valid JSON for the updated car and passengers" do
            car = create(:car, max_seats: 5)
            signup = create(:signup, user: current_user, trip: car.trip)

            patch(car_join_url(car), headers: authorization_headers(current_user))

            expect(response).to have_http_status :ok
            expect_body_to_include_car_attributes(car, car.trip)
            expect_body_to_include_owner_attributes_in_car(car, current_user)

            signup.reload
            expect(signup.car).to eq(car)
          end
        end

        context "car is already full" do
          it "returns 422 Unprocessable Entity" do
            car = create(:car, max_seats: 1)
            owner_signup = create(:signup, trip: car.trip, car: car, user: car.owner)
            signup = create(:signup, user: current_user, trip: car.trip)

            patch(car_join_url(car), headers: authorization_headers(current_user))

            expect(response).to have_http_status :unprocessable_entity
            expect(errors).to eq("Validation failed: Car is full! Sorry!")
            signup.reload
            expect(signup.car).to eq(nil)
          end
        end
      end

      context "user is already signed up for another car in the trip" do
        context "user owns the other car they are currently signed up for" do
          it "returns 422 Unprocessable Entity" do
            owned_car = create(:car, owner: current_user)
            signup = create(:signup, user: current_user, trip: owned_car.trip, car: owned_car)
            new_car = create(:car, trip: owned_car.trip)

            patch(car_join_url(new_car), headers: authorization_headers(current_user))

            expect(response).to have_http_status :unprocessable_entity
            expect(errors).to eq("Could not join car: user owns another car for this trip")
            signup.reload
            expect(signup.car).to eq(owned_car)
          end
        end

        context "user does not own the other car they're currently signed up for" do
          it "updates the signup from one car to the other" do
            car = create(:car, max_seats: 5)
            other_car = create(:car, trip: car.trip, max_seats: 5)
            signup = create(:signup, user: current_user, trip: car.trip, car: other_car)

            patch(car_join_url(car), headers: authorization_headers(current_user))

            expect(response).to have_http_status :ok
            expect_body_to_include_car_attributes(car, car.trip)
            expect(json_value_at_path("car/status")).to eq(car.status)
            signup.reload
            expect(signup.car).to eq(car)
          end
        end
      end

      context "user is already signed up for the car" do
        it "returns 200 OK and the car info" do
          car = create(:car, max_seats: 5)
          signup = create(:signup, car: car, trip: car.trip, user: current_user)

          patch(car_join_url(car), headers: authorization_headers(current_user))

          expect(response).to have_http_status :ok
          expect_body_to_include_car_attributes(car, car.trip)
          signup.reload
          expect(signup.car).to eq(car)
        end
      end

      context "user is not signed up for the car's trip" do
        it "returns Bad Request and JSON with error" do
          car = create(:car, max_seats: 5)

          patch(car_join_url(car), headers: authorization_headers(current_user))

          expect_user_forbidden_response
        end
      end

      context "not a real car id" do
        it "returns 404 Not Found" do
          patch(car_join_url("I'm a car"), headers: authorization_headers(current_user))

          expect(response).to have_http_status :not_found
          expect(errors).to eq("Couldn't find Car with 'id'=I'm a car")
        end
      end
    end

    context "unauthorized user" do
      context "no authorization header" do
        it "returns 401 Unauthorized" do
          car = create(:car, max_seats: 5)

          patch(car_join_url(car), headers: accept_headers)

          expect(response).to have_http_status :unauthorized
        end
      end

      context "invalid access token" do
        it "returns 401 Unauthorized" do
          car = create(:car, max_seats: 5)

          patch(car_join_url(car), headers: invalid_authorization_headers)

          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end
end
