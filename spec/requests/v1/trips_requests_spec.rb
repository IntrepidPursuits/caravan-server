require "rails_helper"

describe "Trip Request", type: :request do
  describe "POST /trips" do
    context "with valid creator, name, departure date, and destination" do
      it "returns valid JSON for the new trip" do
        post(
          api_trips_path,
          params: valid_trip_info.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status :created
        expect(body).to have_json_path("creator_id")
        expect(body).to have_json_path("departure_date")
        expect(body).to have_json_path("destination_address")
        expect(body).to have_json_path("destination_latitude")
        expect(body).to have_json_path("destination_longitude")
        expect(body).to have_json_path("invite_code")
        expect(body).to have_json_path("name")
      end
    end
  end

  def valid_trip_info
    creator = create(:user)
    trip = build(:trip, creator: creator)
    { trip: trip }
  end
end
