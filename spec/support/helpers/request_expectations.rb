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
  end
end
