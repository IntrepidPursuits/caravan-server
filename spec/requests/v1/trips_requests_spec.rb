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
        expect(response).to have_json_path("trip")
      end
    end
  end

  def valid_trip_info
    trip = build(:trip)
    { trip: trip }
  end
end
