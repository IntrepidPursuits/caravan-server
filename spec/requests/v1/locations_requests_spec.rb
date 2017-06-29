require "rails_helper"

describe "Location Request" do
  describe "POST /cars/:car_id/locations" do
    context "authenticated user" do
      let(:current_user) { create(:user) }

      context "with valid latitude and longitude" do
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
          expect(Location.find(parsed_body["trip_locations"]["last_locations"][0]["id"])).to be

          expect(json_value_at_path("trip_locations/trip_id")).to eq(car.trip.id)
          expect(json_value_at_path("trip_locations/last_locations/0/car_id"))
            .to eq(car.id)
          expect(json_value_at_path("trip_locations/last_locations/0/car_name"))
            .to eq(car.name)
          expect(json_value_at_path("trip_locations/last_locations/0/latitude"))
            .to eq(attributes_for(:location)[:latitude].to_s)
          expect(json_value_at_path("trip_locations/last_locations/0/longitude"))
            .to eq(attributes_for(:location)[:longitude].to_s)
        end
      end

      context "with invalid latitude and longitude" do
        it "returns JSON with validation errors" do
          car = create(:car, status: 1)
          signup = create(:signup, car: car, trip: car.trip, user: current_user)
          invalid_location_info = {
            location: {
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
          expect(parsed_body["errors"]).to include ("Validation failed")
          expect(parsed_body["errors"]).to include ("Latitude can't be blank")
          expect(parsed_body["errors"]).to include ("Longitude can't be blank")
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
          expect(parsed_body["errors"])
            .to include ("Cannot update car's location if it has a status of 'Not Started'")
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

          expect(response).to have_http_status(:forbidden)
          expect(parsed_body["errors"])
            .to include "User is not authorized to perform this action"
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

          expect(response).to have_http_status(:forbidden)
          expect(parsed_body["errors"])
            .to include "User is not authorized to perform this action"
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

  describe "GET /trips/:trip_id/locations" do
    context "authenticated user" do
      let(:current_user) { create(:user) }

      context "valid trip" do
        let(:trip) { create(:trip) }

        it "returns most recent locations of each car in the trip" do
          car1 = create(:car, trip: trip, status: 1)
          car2 = create(:car, trip: trip, status: 1)
          create_list(:location, 2, car: car1)
          create_list(:location, 2, car: car2)
          car1_last_location = create(:location, car: car1, latitude: 1.00, longitude: 2.00)
          car2_last_location = create(:location, car: car2, latitude: 3.00, longitude: 4.00)

          get(
            api_v1_trip_locations_url(trip),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :ok
          expect_body_to_include_trip_locations_attributes_at_path("trip_locations")
          expect_body_to_include_locations_attributes_at_path("trip_locations/last_locations/0")
          expect_body_to_include_locations_attributes_at_path("trip_locations/last_locations/1")

          expect(json_value_at_path("trip_locations/trip_id")).to eq trip.id
          expect_body_to_include_locations_content(car1, car1_last_location, 0)
          expect_body_to_include_locations_content(car2, car2_last_location, 1)
        end

        it "does not return nil for cars that don't have any locations" do
          car1 = create(:car, trip: trip, status: 1)
          car2 = create(:car, trip: trip, status: 1)
          location = create(:location, car: car1)

          get(
            api_v1_trip_locations_url(trip),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :ok
          expect_body_to_include_locations_content(car1, location, 0)
          expect(json_value_at_path("trip_locations/last_locations").length).to eq 1
        end
      end

      context "not a real trip id" do
        it "returns JSON with error" do
          get(
            api_v1_trip_locations_url("fake_trip"),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :not_found
          expect(parsed_body["errors"]).to include "Couldn't find Trip with 'id'=fake_trip"
        end
      end
    end

    context "unauthenticated user" do
      context "no authorization header" do
        it "returns 401 Unauthorized" do
          trip = create(:trip)

          get(
            api_v1_trip_locations_url(trip),
            headers: accept_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end

      context "invalid access token" do
        it "returns 401 Unauthorized" do
          trip = create(:trip)

          get(
            api_v1_trip_locations_url(trip),
            headers: invalid_authorization_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end
end
