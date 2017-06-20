require "rails_helper"

describe "Trip Request" do
  describe "POST /trips" do
    context "with valid creator, name, departure date, and destination" do
      it "returns valid JSON for the new trip" do
        unsaved_trip = build(:trip, invite_code: nil)
        valid_trip_info = { trip: unsaved_trip }

        post(
          trips_url,
          params: valid_trip_info.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status :created
        expect(body).to have_json_path("trip")
        expect(body).to have_json_path("trip/creator")
        expect(body).to have_json_path("trip/departing_on")
        expect(body).to have_json_path("trip/destination_address")
        expect(body).to have_json_path("trip/destination_latitude")
        expect(body).to have_json_path("trip/destination_longitude")
        expect(body).to have_json_path("trip/invite_code")
        expect(body).to have_json_path("trip/name")
      end
    end

    context "with invalid data" do
      it "throws an error" do
        invalid_trip_info = {
          trip: {
            creator: nil,
            invite_code: nil,
            destination_address: nil,
            destination_latitude: nil,
            destination_longitude: nil,
            name: nil
          }
        }

        post(
          trips_url,
          params: invalid_trip_info.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status :unprocessable_entity
        expect(body).to have_json_path("errors")
        expect(parsed_body["errors"]).to include ("Validation failed")
        expect(parsed_body["errors"]).to include ("Creator must exist")
        expect(parsed_body["errors"]).to include ("Creator can't be blank")
        expect(parsed_body["errors"]).to include ("Departing on can't be blank")
        expect(parsed_body["errors"]).to include ("Destination address can't be blank")
        expect(parsed_body["errors"]).to include ("Destination longitude can't be blank")
        expect(parsed_body["errors"]).to include ("Destination latitude can't be blank")
        expect(parsed_body["errors"]).to include ("Name can't be blank")
      end
    end
  end
end
