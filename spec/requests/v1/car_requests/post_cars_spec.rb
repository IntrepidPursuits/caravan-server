require "rails_helper"

describe "Car Requests" do
  describe "POST /cars" do
    context "authenticated user" do
      let(:current_user) { create(:user) }
      let!(:google_identity) { create(:google_identity, user: current_user) }

      context "for a new car on a trip that the user is signed up for" do
        context "with valid trip, max_seats, name, and status" do
          before(:each) do
            @signup = create(:signup, user: current_user)
            unsaved_car = build(:car, trip: @signup.trip)

            valid_car_info = {
              car: unsaved_car
            }

            post(
              api_v1_cars_url,
              params: valid_car_info.to_json,
              headers: authorization_headers(current_user)
            )
          end

          it "returns valid JSON for the new car" do
            expect(response).to have_http_status :created
            expect_body_to_include_car_attributes_at_path("car")

            car = parsed_body["car"]
            expect(Car.find(car["id"])).to be
            expect(car["locations"]).to eq []
            expect(car["max_seats"]).to eq(1)
            expect(car["name"]).to include("Car ")
            expect(car["status"]).to eq("not_started")

            expect(json_value_at_path("car/owner_id")).to eq current_user.id

            trip = @signup.trip
            expect(car["trip"]["id"]).to eq trip.id
            expect(car["trip"]["name"]).to eq trip.name
          end

          it "automatically adds the current user to the car" do
            expect(json_value_at_path("car/passengers").length).to eq 1
            expect_body_to_include_passenger_attributes
          end
        end
      end

      context "with valid trip and invalid other info" do
        it "returns 422 Unprocessable Entity" do
          signup = create(:signup, user: current_user)
          invalid_car_info = {
            car: {
              trip_id: signup.trip_id,
              max_seats: nil,
              name: nil,
              status: nil
            }
          }

          post(
            api_v1_cars_url,
            params: invalid_car_info.to_json,
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :unprocessable_entity
          errors = ["Max seats can't be blank", "Max seats is not a number",
            "Name can't be blank", "Status can't be blank"]

          errors.each do |error|
            expect(parsed_body["errors"]).to include error
          end
        end
      end

      context "with no trip" do
        it "returns 422 Unprocessable Entity" do
          invalid_car_info = {
            car: {
              trip_id: nil,
              name: "Cool Kids' Ride"
            }
          }

          post(
            api_v1_cars_url,
            params: invalid_car_info.to_json,
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :unprocessable_entity
          expect(parsed_body["errors"])
            .to eq "You must provide a valid trip_id in order to create a car"
        end
      end

      context "with invalid trip" do
        context "user is not signed up for the trip" do
          it "returns 403 Forbidden" do
            trip = create(:trip)
            invalid_car_info = {
              car: {
                trip_id: trip.id,
                name: "The Boogy Buggy"
              }
            }

            post(
              api_v1_cars_url,
              params: invalid_car_info.to_json,
              headers: authorization_headers(current_user)
            )

            expect_user_forbidden_response
          end
        end

        context "trip doesn't exist at all" do
          it "returns 404 Not Found" do
            invalid_car_info = {
              car: {
                trip_id: "not a trip",
                max_seats: 1,
                name: "The Cool Car",
                status: 0
              }
            }

            post(
              api_v1_cars_url,
              params: invalid_car_info.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :not_found
            expect(parsed_body["errors"])
              .to include "Couldn't find Trip with 'id'=not a trip"
          end
        end
      end

      context "with no information" do
        it "returns 400 Bad Request" do
          empty_car_info = { car: {} }

          post(
            api_v1_cars_url,
            params: empty_car_info.to_json,
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :bad_request
          expect(parsed_body["errors"])
            .to eq "param is missing or the value is empty: car"
        end
      end
    end

    context "unauthenticated user" do
      let!(:unsaved_car) { build(:car) }
      let!(:valid_car_info) { { car: unsaved_car } }

      context "no authorization header" do
        it "returns 401 Unauthorized" do
          post(
            api_v1_cars_url,
            params: valid_car_info.to_json,
            headers: accept_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end

      context "invalid access token" do
        it "returns 401 Unauthorized" do
          post(
            api_v1_cars_url,
            params: valid_car_info.to_json,
            headers: invalid_authorization_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end
end
