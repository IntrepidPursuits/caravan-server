require "rails_helper"

describe "Trip Request" do
  describe "POST /trips" do
    context "authenticated user" do
      let(:current_user) { create(:user) }

      context "with valid creator, name, departure date, and destination" do
        it "returns valid JSON for the new trip" do
          unsaved_trip = build(:trip, invite_code: nil, creator_id: nil)
          valid_trip_info = { trip: unsaved_trip }

          post(
            trips_url,
            params: valid_trip_info.to_json,
            headers: authorization_headers(current_user)
          )

          new_trip_id = json_value_at_path("trip/id")

          expect(response).to have_http_status :created
          expect_response_to_include_complete_trip_attributes_at_path("trip")
          expect_response_to_include_correct_trip_factory_content(current_user)
          expect(Trip.find(new_trip_id)).to be
          expect(Signup.find_by(user: current_user, trip_id: new_trip_id)).to be
        end
      end

      context "with invalid data" do
        it "returns JSON with validation errors" do
          invalid_trip_info = {
            trip: {
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
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :unprocessable_entity
          expect(body).to have_json_path("errors")
          expect(errors).to include("Validation failed")
          expect(errors).to include("Departing on can't be blank")
          expect(errors).to include("Destination address can't be blank")
          expect(errors).to include("Destination longitude can't be blank")
          expect(errors).to include("Destination latitude can't be blank")
          expect(errors).to include("Name can't be blank")
        end
      end
    end

    context "unauthenticated user" do
      context "no authorization header" do
        it "returns 401 Unauthorized" do
          unsaved_trip = build(:trip, invite_code: nil, creator_id: nil)
          valid_trip_info = { trip: unsaved_trip }

          post(
            trips_url,
            params: valid_trip_info.to_json,
            headers: accept_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end

      context "invalid access token" do
        it "returns 401 Unauthorized" do
          unsaved_trip = build(:trip, invite_code: nil, creator_id: nil)
          valid_trip_info = { trip: unsaved_trip }

          post(
            trips_url,
            params: valid_trip_info.to_json,
            headers: invalid_authorization_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end
end
