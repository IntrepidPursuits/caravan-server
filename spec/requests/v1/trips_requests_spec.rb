require "rails_helper"

describe "Trip Request", type: :request do
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
        expect(body).to have_json_path("trip/creator_id")
        expect(body).to have_json_path("trip/departing_on")
        expect(body).to have_json_path("trip/destination_address")
        expect(body).to have_json_path("trip/destination_latitude")
        expect(body).to have_json_path("trip/destination_longitude")
        expect(body).to have_json_path("trip/invite_code")
        expect(body).to have_json_path("trip/name")
        expect(body).to have_json_path("trip/cars")
        expect(body).to have_json_path("trip/cars/0/max_seats")
        expect(body).to have_json_path("trip/cars/0/status")
        expect(body).to have_json_path("trip/signed_up_users")
        expect(body).to have_json_path("trip/signed_up_users/0/name")
      end
    end
  end

  def valid_trip_info
    creator = create(:user)
    trip = build(:trip, creator: creator)
    { trip: trip }
  end
end
