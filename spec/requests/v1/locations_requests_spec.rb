require "rails_helper"

describe "Location Request" do
  describe "POST /cars/:car_id/locations" do
    context "with valid latitude and longitude" do
      it "returns valid JSON with list of locations of other cars in the trip" do
        car = create(:car)
        unsaved_location = build(:location, car: nil)
        valid_location_info = { location: unsaved_location }

        post(
          car_locations_url(car),
          params: valid_location_info.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status :created
        expect(body).to have_json_path("trip_locations")
        expect(body).to have_json_path("trip_locations/trip_id")
        expect(body).to have_json_path("trip_locations/last_locations")
        expect(body).to have_json_path("trip_locations/last_locations/0/id")
        expect(body).to have_json_path("trip_locations/last_locations/0/car_id")
        expect(body).to have_json_path("trip_locations/last_locations/0/latitude")
        expect(body).to have_json_path("trip_locations/last_locations/0/longitude")

        expect(parsed_body["trip_locations"]["trip_id"]).to eq(car.trip.id)
        expect(parsed_body["trip_locations"]["last_locations"][0]["car_id"])
          .to eq(car.id)
        expect(parsed_body["trip_locations"]["last_locations"][0]["latitude"])
          .to eq(attributes_for(:location)[:latitude].to_s)
        expect(parsed_body["trip_locations"]["last_locations"][0]["longitude"])
          .to eq(attributes_for(:location)[:longitude].to_s)
      end
    end

    context "with invalid latitude and longitude" do
      it "returns JSON with validation errors" do
        car = create(:car)
        invalid_location_info = {
          location: {
            latitude: nil,
            longitude: nil
          }
        }

        post(
          car_locations_url(car),
          params: invalid_location_info.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status :unprocessable_entity
        expect(body).to have_json_path("errors")
        expect(parsed_body["errors"]).to include ("Validation failed")
        expect(parsed_body["errors"]).to include ("Latitude can't be blank")
        expect(parsed_body["errors"]).to include ("Longitude can't be blank")
      end
    end
  end
end
