require "rails_helper"

describe "Trip Request" do
  describe "POST /trips" do
    context "with valid creator, name, departure date, and destination" do
      it "returns valid JSON for the new trip" do
        post(
          api_v1_trips_url,
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
  end

  def valid_trip_info
    creator = create(:user)
    trip = build(:trip, creator: creator, invite_code: nil)
    { trip: trip }
  end
end
