module Helpers
  module RequestExpectations
    def expect_body_to_include_car_attributes(car, trip, user)
      expect(parsed_body["car"]["id"]).to eq car.id
      expect(parsed_body["car"]["locations"]).to eq []
      expect(parsed_body["car"]["max_seats"]).to eq car.max_seats
      expect(parsed_body["car"]["name"]).to eq car.name
      expect(parsed_body["car"]["status"]).to eq car.status
      expect(parsed_body["car"]["trip"]["id"]).to eq trip.id
      expect(parsed_body["car"]["trip"]["name"]).to eq trip.name
      expect(parsed_body["car"]["passengers"][0]["id"]).to eq user.id
      expect(parsed_body["car"]["passengers"][0]["name"]).to eq user.name
      expect(parsed_body["car"]["passengers"][0]["email"]).to eq user.google_identity.email
    end

    def expect_body_to_include_trip_locations_attributes_at_path(path)
      expect(body).to have_json_path("#{path}")
      expect(body).to have_json_path("#{path}/trip_id")
      expect(body).to have_json_path("#{path}/last_locations")
    end

    def expect_body_to_include_locations_attributes_at_path(path)
      expect(body).to have_json_path("#{path}/id")
      expect(body).to have_json_path("#{path}/car_id")
      expect(body).to have_json_path("#{path}/latitude")
      expect(body).to have_json_path("#{path}/longitude")
    end

    def expect_body_to_include_locations_content(car, location, index)
      expect(parsed_body["trip_locations"]["last_locations"][index]["car_id"])
        .to eq car.id
      expect(parsed_body["trip_locations"]["last_locations"][index]["latitude"])
        .to eq location.latitude.to_s
      expect(parsed_body["trip_locations"]["last_locations"][index]["longitude"])
        .to eq location.longitude.to_s

    def expect_body_to_include_car_attributes_at_path(path)
      expect(body).to have_json_path(path)
      expect(body).to have_json_path("#{path}/id")
      expect(body).to have_json_path("#{path}/locations")
      expect(body).to have_json_path("#{path}/max_seats")
      expect(body).to have_json_path("#{path}/name")
      expect(body).to have_json_path("#{path}/passengers")
      expect(body).to have_json_path("#{path}/status")
      expect(body).to have_json_path("#{path}/trip")
      expect(body).to have_json_path("#{path}/trip/code")
      expect(body).to have_json_path("#{path}/trip/creator")
      expect(body).to have_json_path("#{path}/trip/departing_on")
      expect(body).to have_json_path("#{path}/trip/destination_address")
      expect(body).to have_json_path("#{path}/trip/destination_latitude")
      expect(body).to have_json_path("#{path}/trip/destination_longitude")
      expect(body).to have_json_path("#{path}/trip/id")
      expect(body).to have_json_path("#{path}/trip/name")
    end

    def expect_body_to_include_passenger_attributes
      parsed_body["car"]["passengers"].first do |passenger|
        expect(passenger["id"]).to eq current_user.id
        expect(passenger["name"]).to eq current_user.name
        expect(passenger["email"]).to eq google_identity.email
      end
    end
  end
end
