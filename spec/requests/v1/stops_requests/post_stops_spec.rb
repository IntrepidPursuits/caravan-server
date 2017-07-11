require "rails_helper"

describe "Stop Request" do
  describe "POST /trips/:trip_id/stops" do
    context "authenticated user" do
      let!(:current_user) { create(:user) }

      context "user is signed up for the trip" do
        let!(:trip) { create(:trip) }
        let!(:signup) { create(:signup, trip: trip, user: current_user) }

        context "with valid info" do
          it "returns valid JSON for the stop" do
            unsaved_stop = build(:stop, trip: nil)
            stop_params = { stop: unsaved_stop }

            post(
              api_v1_trip_stops_url(trip),
              params: stop_params.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :created
            stop = Stop.find_by(trip: trip, name: unsaved_stop.name)
            expect(stop).to be
            expect(json_value_at_path("stop/id")).to be
            expect(json_value_at_path("stop/trip_id")).to eq(trip.id)
            expect(json_value_at_path("stop/name")).to eq(unsaved_stop.name)
            expect(json_value_at_path("stop/address")).to eq(unsaved_stop.address)
            expect(json_value_at_path("stop/description")).to eq(nil)
            expect(json_value_at_path("stop/latitude")).to eq("71.304")
            expect(json_value_at_path("stop/longitude")).to eq("53.46")
          end
        end

        context "with invalid info" do
          context "nil values" do
            it "raises 422 Unprocessable Entity" do
              stop_params = { stop: {
                address: nil,
                name: nil,
                description: nil,
                latitude: nil,
                longitude: nil
                } }

              post(
                api_v1_trip_stops_url(trip),
                params: stop_params.to_json,
                headers: authorization_headers(current_user)
              )

              expect(response).to have_http_status :unprocessable_entity
              expect(errors).to include("Validation failed")
              expect(errors).to include("Address can't be blank")
              expect(errors).to include("Name can't be blank")
              expect(errors).to include("Latitude can't be blank")
              expect(errors).to include("Longitude can't be blank")
            end
          end

          context "invalid latitude & longitude" do
            it "raises 422 Unprocessable Entity" do
              stop_params = { stop: {
                address: 1.4,
                name: 2,
                latitude: "hey there",
                longitude: "Marjie is pretty and smart"
                } }

              post(
                api_v1_trip_stops_url(trip),
                params: stop_params.to_json,
                headers: authorization_headers(current_user)
              )

              expect(response).to have_http_status :unprocessable_entity
              expect(errors).to include("Validation failed")
              expect(errors).to include("Latitude is not a number")
              expect(errors).to include("Longitude is not a number")
            end
          end

          context "missing values" do
            it "raises 400 Bad Request" do
              post(
              api_v1_trip_stops_url(trip),
              headers: authorization_headers(current_user)
              )

              expect(response).to have_http_status :bad_request
              expect(errors).to eq("param is missing or the value is empty: stop")
            end
          end
        end

        context "user is not signed up for the trip" do
          it "returns 403 Forbidden" do
            trip = create(:trip)
            unsaved_stop = build(:stop, trip: nil)
            stop_params = { stop: unsaved_stop }

            post(
              api_v1_trip_stops_url(trip),
              params: stop_params.to_json,
              headers: authorization_headers(current_user)
            )

            expect_user_forbidden_response
          end
        end

        context "invalid trip_id" do
          it "returns 404 Not Found" do
            unsaved_stop = build(:stop, trip: nil)
            stop_params = { stop: unsaved_stop }

            post(
              api_v1_trip_stops_url("This is not a pipe"),
              params: stop_params.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :not_found
            expect(errors).to eq("Couldn't find Trip with 'id'=This is not a pipe")
          end
        end
      end
    end

    context "unauthenticated user" do
      let!(:trip) { create(:trip) }

      context "no authorization header" do
        it "returns 401 Unauthorized" do
          valid_stop = build(:stop, trip: nil)
          stop_params = { stop: valid_stop }

          post(
            api_v1_trip_stops_url(trip),
            params: stop_params.to_json,
            headers: accept_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end

      context "with invalid token" do
        it "returns 401 Unauthorized" do
          valid_stop = build(:stop, trip: nil)
          stop_params = { stop: valid_stop }

          post(
            api_v1_trip_stops_url(trip),
            params: stop_params.to_json,
            headers: invalid_authorization_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end
end
