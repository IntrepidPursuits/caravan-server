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

        expect(parsed_body["trip"]["creator"]["name"])
          .to eq attributes_for(:user)[:name]
        expect(parsed_body["trip"]["destination_address"])
          .to eq attributes_for(:trip)[:destination_address].to_s
        expect(parsed_body["trip"]["destination_latitude"])
          .to eq attributes_for(:trip)[:destination_latitude].to_s
        expect(parsed_body["trip"]["destination_longitude"])
          .to eq attributes_for(:trip)[:destination_longitude].to_s
        expect(parsed_body["trip"]["cars"].empty?).to be true
      end
    end

    context "with invalid data" do
      it "returns JSON with validation errors" do
        invalid_trip_info = {
          trip: {
            creator: nil,
            destination_address: nil,
            destination_latitude: nil,
            destination_longitude: nil,
            invite_code: nil,
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

  describe "GET /trips/:id" do
    it "returns valid JSON for an individual trip" do
      create_list(:user, 3)
      trip = create(:trip, creator: User.first)
      create_list(:car, 3, trip: trip)

      user = User.first
      user2 = User.second
      user3 = User.third
      create(:signup, trip: trip, user: user)
      create(:signup, trip: trip, user: user2)
      create(:signup, trip: trip, user: user3)

      get(trip_url(trip))

      expect(response).to have_http_status :ok
      expect(body).to have_json_path("trip")
      expect(body).to have_json_path("trip/creator")
      expect(body).to have_json_path("trip/creator/name")
      expect(body).to have_json_path("trip/departing_on")
      expect(body).to have_json_path("trip/destination_address")
      expect(body).to have_json_path("trip/destination_latitude")
      expect(body).to have_json_path("trip/destination_longitude")
      expect(body).to have_json_path("trip/code")
      expect(body).to have_json_path("trip/name")
      expect(body).to have_json_path("trip/cars")
      expect(body).to have_json_path("trip/cars/0/max_seats")
      expect(body).to have_json_path("trip/cars/0/name")
      expect(body).to have_json_path("trip/cars/0/status")
      expect(body).to have_json_path("trip/signed_up_users")
      expect(body).to have_json_path("trip/signed_up_users/0/name")
    end
  end
end
