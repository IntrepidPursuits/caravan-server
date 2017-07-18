require "rails_helper"

describe "Trip Request" do
  describe "GET /trips/:id" do
    context "authenticated user" do
      let(:current_user) { create(:user) }

      context "valid trip" do
        it "returns valid JSON for an individual trip" do
          trip = create(:trip, creator: current_user)

          passengers = create_list(:user, 3)
          passengers.each do |passenger|
            create(:google_identity, user: passenger)
            car = create(:car, owner: passenger, trip: trip)
            create(:signup, trip: trip, user: passenger, car: car)
          end

          get(
            api_v1_trip_url(trip),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :ok
          expect_response_to_include_complete_trip_attributes_at_path("trip")
          expect_response_to_include_correct_trip_factory_content(current_user)
          expect_response_to_include_trip_with_cars_attributes_at_path(
            "trip/cars", trip.cars.length)
        end

        it "returns the cars in alphabetical order" do
          trip = create(:trip, creator: current_user)
          car_1 = create(:car, trip: trip, name: "A")
          car_2 = create(:car, trip: trip, name: "C")
          car_3 = create(:car, trip: trip, name: "B")

          get(
            api_v1_trip_url(trip),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :ok
          expect(json_value_at_path("trip/cars/0/name")).to eq("A")
          expect(json_value_at_path("trip/cars/1/name")).to eq("B")
          expect(json_value_at_path("trip/cars/2/name")).to eq("C")
        end
      end

      context "not a real trip id" do
        it "returns JSON with error" do
          get(
            api_v1_trip_url("fake_trip"),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :not_found
          expect(parsed_body["errors"])
            .to include "Couldn't find Trip with 'id'=fake_trip"
        end
      end
    end

    context "unauthenticated user" do
      let(:trip) { create(:trip) }

      context "no authorization header" do
        it "returns 401 Unauthorized" do
          get(
            api_v1_trip_url(trip),
            headers: accept_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end

      context "invalid access token" do
        it "returns 401 Unauthorized" do
          get(
            api_v1_trip_url(trip),
            headers: invalid_authorization_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end
end
