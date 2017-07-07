require "rails_helper"

describe "Location Request" do
  describe "GET /trips/:trip_id/locations" do
    context "authenticated user" do
      let(:current_user) { create(:user) }

      context "valid trip" do
        let(:trip) { create(:trip) }

        context "trip has multiple cars with locations" do
          it "returns most recent locations of each car in the trip" do
            create(:signup, trip: trip, user: current_user)
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
        end

        context "some cars don't have any locations" do
          it "does not return nil; only returns locations that exist" do
            create(:signup, trip: trip, user: current_user)
            car1 = create(:car, trip: trip, status: 1)
            car2 = create(:car, trip: trip, status: 1)
            location = create(:location, car: car1)

            get(
              api_v1_trip_locations_url(trip),
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :ok
            expect_body_to_include_locations_content(car1, location, 0)
            expect(json_value_at_path("trip_locations/last_locations").count).to eq 1
          end
        end
      end

      context "invalid trip id" do
        it "returns 404 Not Found" do
          get(
            api_v1_trip_locations_url("fake_trip"),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :not_found
          expect(errors).to include "Couldn't find Trip with 'id'=fake_trip"
        end
      end

      context "user is not signed up for the trip" do
        it "returns 403 Forbidden" do
          trip = create(:trip)
          locations = create_list(:location, 3, trip: trip)

          get(
            api_v1_trip_locations_url(trip),
            headers: authorization_headers(current_user)
          )

          expect_user_forbidden_response
        end
      end

      context "user tries to signed for a car in the trip, but not the trip itself" do
        it "returns 403 Forbidden" do
          trip = create(:trip)
          car = create(:car, trip: trip)
          locations = create_list(:location, 3, trip: trip, car: car)
          expect{ create(:signup, car: car, user: current_user) }
            .to raise_error(ActiveRecord::RecordInvalid)

          get(
            api_v1_trip_locations_url(trip),
            headers: authorization_headers(current_user)
          )

          expect_user_forbidden_response
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
