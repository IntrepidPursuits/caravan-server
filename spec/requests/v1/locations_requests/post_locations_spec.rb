require "rails_helper"

describe "Location Request" do
  describe "POST /cars/:car_id/locations" do
    context "authenticated user" do
      let(:current_user) { create(:user) }

      context "with valid attributes" do
        it "returns valid JSON with list of locations of other cars in the trip" do
          car = create(:car, status: 1)
          signup = create(:signup, car: car, trip: car.trip, user: current_user)
          unsaved_location = build(:location, car: nil)
          valid_location_info = { location: unsaved_location }

          post(
            car_locations_url(car),
            params: valid_location_info.to_json,
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :created
          expect_body_to_include_trip_locations_attributes_at_path("trip_locations")
          expect_body_to_include_locations_attributes_at_path("trip_locations/last_locations/0")

          location = Location.find(json_value_at_path("trip_locations/last_locations/0/id"))
          expect(location).to be

          expect(json_value_at_path("trip_locations/trip_id")).to eq(car.trip.id)
          expect(json_value_at_path("trip_locations/last_locations/0/car_id"))
            .to eq(car.id)
          expect(json_value_at_path("trip_locations/last_locations/0/car_name"))
            .to eq(car.name)
          expect(json_value_at_path("trip_locations/last_locations/0/direction"))
            .to eq(attributes_for(:location)[:direction])
          expect(json_value_at_path("trip_locations/last_locations/0/latitude"))
            .to eq(attributes_for(:location)[:latitude].to_s)
          expect(json_value_at_path("trip_locations/last_locations/0/longitude"))
            .to eq(attributes_for(:location)[:longitude].to_s)
        end
      end

      context "with no direction specified" do
        it "defaults direction to zero and returns 201 created" do
          car = create(:car, status: 1)
          signup = create(:signup, car: car, trip: car.trip, user: current_user)
          invalid_location_info = {
            location: {
              latitude: 12.0,
              longitude: -36.5
            }
          }

          post(
            car_locations_url(car),
            params: invalid_location_info.to_json,
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :created
          expect_body_to_include_trip_locations_attributes_at_path("trip_locations")
          expect_body_to_include_locations_attributes_at_path("trip_locations/last_locations/0")

          location = Location.find(json_value_at_path("trip_locations/last_locations/0/id"))
          expect(location).to be
          expect(location.direction).to eq 0
        end
      end

      context "with all invalid attributes" do
        it "returns JSON with validation errors" do
          car = create(:car, status: 1)
          signup = create(:signup, car: car, trip: car.trip, user: current_user)
          invalid_location_info = {
            location: {
              direction: nil,
              latitude: nil,
              longitude: nil
            }
          }

          post(
            car_locations_url(car),
            params: invalid_location_info.to_json,
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :unprocessable_entity
          expect(body).to have_json_path("errors")
          expect(errors).to include "Validation failed"
          expect(errors).to include "Latitude can't be blank"
          expect(errors).to include "Longitude can't be blank"
          expect(errors).to include "Direction must be between -180 & 180"
          expect(errors).to include "Direction is not a number"
          expect(errors).to include "Direction can't be blank"
        end
      end

      context "with invalid latitude and longitude, but valid direction" do
        it "returns JSON with validation errors" do
          car = create(:car, status: 1)
          signup = create(:signup, car: car, trip: car.trip, user: current_user)
          invalid_location_info = {
            location: {
              direction: -2,
              latitude: nil,
              longitude: nil
            }
          }

          post(
            car_locations_url(car),
            params: invalid_location_info.to_json,
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :unprocessable_entity
          expect(body).to have_json_path("errors")
          expect(errors).to include ("Validation failed")
          expect(errors).to include ("Latitude can't be blank")
          expect(errors).to include ("Longitude can't be blank")
        end
      end

      context "with invalid direction" do
        context "with nil direction" do
          it "returns validation errors" do
            car = create(:car, status: 1)
            signup = create(:signup, car: car, trip: car.trip, user: current_user)
            invalid_location_info = {
              location: {
                direction: nil,
                latitude: 1.4,
                longitude: -70.3
              }
            }

            post(
              car_locations_url(car),
              params: invalid_location_info.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :unprocessable_entity
            expect(errors).to include "Validation failed"
            expect(errors).to include "Direction must be between -180 & 180"
            expect(errors).to include "Direction is not a number"
            expect(errors).to include "Direction can't be blank"
          end
        end

        context "with a number outside the range" do
          it "returns validation errors" do
            car = create(:car, status: 1)
            signup = create(:signup, car: car, trip: car.trip, user: current_user)
            invalid_location_info = {
              location: {
                direction: -190,
                latitude: 1.4,
                longitude: -70.3
              }
            }

            post(
              car_locations_url(car),
              params: invalid_location_info.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :unprocessable_entity
            expect(errors).to include "Validation failed"
            expect(errors).to include "Direction must be between -180 & 180"
          end
        end

        context "with a decimal" do
          it "returns validation errors" do
            car = create(:car, status: 1)
            signup = create(:signup, car: car, trip: car.trip, user: current_user)
            invalid_location_info = {
              location: {
                direction: 19.3,
                latitude: 1.4,
                longitude: -70.3
              }
            }

            post(
              car_locations_url(car),
              params: invalid_location_info.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :unprocessable_entity
            expect(errors).to include "Validation failed"
            expect(errors).to include "Direction must be an integer"
          end
        end
      end

      context "with car that hasn't started trip yet" do
        it "returns JSON with validation errors" do
          car = create(:car)
          signup = create(:signup, car: car, trip: car.trip, user: current_user)
          invalid_car_status = {
            location: {
              latitude: 1.0,
              longitude: 2.0
            }
          }

          post(
            car_locations_url(car),
            params: invalid_car_status.to_json,
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :unprocessable_entity
          expect(body).to have_json_path("errors")
          expect(errors)
            .to include ("Cannot update car's location if it has a status of 'Not Started'")
        end
      end

      context "with an invalid car_id" do
        it "returns 404 Not Found" do

        end
      end

      context "car belongs to a different trip than specified" do
        it "returns 404 Not Found" do

        end
      end

      context "user is not signed up for the trip" do
        it "returns 403 Forbidden" do
          car = create(:car, status: 1)
          unsaved_location = build(:location, car: nil)
          valid_location_info = { location: unsaved_location }

          post(
            car_locations_url(car),
            params: valid_location_info.to_json,
            headers: authorization_headers(current_user)
          )

          expect_user_forbidden_response
        end
      end

      context "user is signed up for trip but not in the car" do
        it "returns 403 Forbidden" do
          car = create(:car, status: 1)
          signup = create(:signup, trip: car.trip, user: current_user)
          unsaved_location = build(:location, car: nil)
          valid_location_info = { location: unsaved_location }

          post(
            car_locations_url(car),
            params: valid_location_info.to_json,
            headers: authorization_headers(current_user)
          )

          expect_user_forbidden_response
        end
      end
    end

    context "unauthenticated user" do
      context "no authorization header" do
        it "returns 401 Unauthorized" do
          car = create(:car)
          unsaved_location = build(:location, car: nil)
          valid_location_info = { location: unsaved_location }

          post(
            car_locations_url(car),
            params: valid_location_info.to_json,
            headers: accept_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end

      context "invalid access token" do
        it "returns 401 Unauthorized" do
          car = create(:car)
          unsaved_location = build(:location, car: nil)
          valid_location_info = { location: unsaved_location }

          post(
            car_locations_url(car),
            params: valid_location_info.to_json,
            headers: invalid_authorization_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end
end
