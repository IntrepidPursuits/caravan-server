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

  describe "GET /trips/:trip_id/locations" do
    it "returns most recent locations of each car in the trip" do
      trip = create(:trip)
      car1 = create(:car, trip: trip)
      car2 = create(:car, trip: trip)
      create_list(:location, 2, car: car1)
      create_list(:location, 2, car: car2)
      car1_last_location = create(:location, car: car1, latitude: 1.00, longitude: 2.00)
      car2_last_location = create(:location, car: car2, latitude: 3.00, longitude: 4.00)

      get(api_v1_trip_locations_url(trip))

      expect(response).to have_http_status :ok
      expect(parsed_body["trip_locations"]["trip_id"]).to eq trip.id
      expect(parsed_body["trip_locations"]["last_locations"][0]["car_id"])
        .to eq car1.id
      expect(parsed_body["trip_locations"]["last_locations"][0]["latitude"])
        .to eq car1_last_location.latitude.to_s
      expect(parsed_body["trip_locations"]["last_locations"][0]["longitude"])
        .to eq car1_last_location.longitude.to_s
      expect(parsed_body["trip_locations"]["last_locations"][1]["car_id"])
        .to eq car2.id
      expect(parsed_body["trip_locations"]["last_locations"][1]["latitude"])
        .to eq car2_last_location.latitude.to_s
      expect(parsed_body["trip_locations"]["last_locations"][1]["longitude"])
        .to eq car2_last_location.longitude.to_s
    end
  end
end
