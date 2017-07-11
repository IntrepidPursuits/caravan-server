require "rails_helper"

describe "Stop Request" do
  describe "POST /trips/:trip_id/stops" do
    context "authenticated user" do
      context "user is signed up for the trip" do
        context "with valid info" do
          it "returns valid JSON for the stop" do
            current_user = create(:user)
            trip = create(:trip)
            create(:signup, trip: trip, user: current_user)
            unsaved_stop = build(:stop, trip: nil)
            stop_params = { stop: unsaved_stop }

            post(
              api_v1_trip_stops_url(trip),
              params: stop_params.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :created
            expect(json_body_at_path("stop/id")).to be
            expect(json_body_at_path("stop/trip_id")).to eq(trip.id)
            expect(json_body_at_path("stop/name")).to include("My Stop ")
            expect(json_body_at_path("stop/address")).to include("150 First St ")
            expcet(json_body_at_path("stop/description")).to eq(nil)
            expect(json_body_at_path("stop/latitude")).to eq("71.304")
            expect(json_body_at_path("stop/longitude")).to eq("53.46")
          end
        end

        context "with invalid info" do
          context "nil values" do
            it "raises 400 Bad Request" do

            end
          end

          context "missing values" do
            it "raises 400 Bad Request" do

            end
          end

          context "invalid values" do
            it "raises 422 Unprocessable Entity" do

            end
          end
        end

        context "user is not signed up for the trip" do
          it "returns 403 Forbidden" do

          end
        end

        context "invalid trip_id" do
          it "returns 404 Not Found" do

          end
        end
      end
    end

    context "unauthenticated user" do
      context "no authorization header" do
        it "returns 401 Unauthorized" do

        end
      end

      context "with invalid token" do
        it "returns 401 Unauthorized" do

        end
      end
    end
  end
end
