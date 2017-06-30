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
          expect_reponse_to_include_correct_trip_factory_content(current_user)
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
          expect(parsed_body["errors"]).to include ("Validation failed")
          expect(parsed_body["errors"]).to include ("Departing on can't be blank")
          expect(parsed_body["errors"]).to include ("Destination address can't be blank")
          expect(parsed_body["errors"]).to include ("Destination longitude can't be blank")
          expect(parsed_body["errors"]).to include ("Destination latitude can't be blank")
          expect(parsed_body["errors"]).to include ("Name can't be blank")
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

  describe "GET /trips/:id" do
    context "authenticated user" do
      let(:current_user) { create(:user) }

      context "valid trip" do
        it "returns valid JSON for an individual trip" do
          create_list(:user, 3)
          trip = create(:trip)
          create_list(:car, 3, trip: trip)

          user = User.first
          user2 = User.second
          user3 = User.third
          create(:signup, trip: trip, user: user)
          create(:signup, trip: trip, user: user2)
          create(:signup, trip: trip, user: user3)

          get(
            api_v1_trip_url(trip),
            headers: authorization_headers(user)
          )

          expect(response).to have_http_status :ok
          expect_response_to_include_complete_trip_attributes_at_path("trip")
          expect_reponse_to_include_correct_trip_factory_content(current_user)
          expect_response_to_include_trip_with_cars_attributes_at_path(
            "trip/cars", trip.cars.length)
          expect_response_to_include_trip_with_signups_attributes_at_path(
            "trip/signed_up_users", trip.users.length)
        end
      end

      context "not a real trip id" do
        it "returns JSON with error" do
          get(
            api_v1_trip_url("fake_trip"),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :not_found
          expect(parsed_body["errors"])
            .to include "Couldn't find Trip with 'id'=fake_trip"
        end
      end
    end

    context "unauthenticated user" do
      let(:trip) { create(:trip) }

      context "no authorization header" do
        it "returns 401 Unauthorized" do
          get(
            api_v1_trip_url(trip),
            headers: accept_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end

      context "invalid access token" do
        it "returns 401 Unauthorized" do
          get(
            api_v1_trip_url(trip),
            headers: invalid_authorization_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end

  describe "GET /users/:user_id/trips" do
    context "authenticated user" do
      let(:current_user) { create(:user) }

      context "when the user is not yet signed up for any trips" do
        it "shows and empty array" do
          get(
            api_v1_user_trips_url(current_user),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :ok
          expect(parsed_body["trips"]).to be_a(Array)
          expect(parsed_body["trips"]).to eq []
        end
      end

      context "when the user is signed up for at least one trip" do
        let(:trip_1) { create(:trip) }
        let!(:signups) { create(:signup, user: current_user, trip: trip_1) }

        it "shows JSON for all the current user's trips" do
          get(
            api_v1_user_trips_url(current_user),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :ok
          expect(parsed_body["trips"]).to be_a(Array)

          trips = parsed_body["trips"]

          expect(trips[0]["code"]).to eq(trip_1.invite_code.code)
          expect(trips[0]["departing_on"]).to match(trip_1.departing_on)
          expect(trips[0]["destination_address"]).to eq(trip_1.destination_address)
          expect(trips[0]["destination_latitude"]).to eq(trip_1.destination_latitude.to_s)
          expect(trips[0]["destination_longitude"]).to eq(trip_1.destination_longitude.to_s)
          expect(trips[0]["id"]).to eq(trip_1.id)
          expect(trips[0]["name"]).to eq(trip_1.name)
        end

        it "does not show trips that the user has not signed up for" do
          trip_2 = create(
            :trip,
            destination_address: "8 Harry Potter Rd",
            name: "Spelunking Trip"
          )

          get(
            api_v1_user_trips_url(current_user),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :ok

          trips = parsed_body["trips"]
          trips.each_with_index do |trip, index|
            expect(trips[index]["id"]).to_not eq trip_2.id
            expect(trips[index]["name"]).to_not eq trip_2.name
            expect(trips[index]["code"]).to_not eq trip_2.invite_code.code
            expect(trips[index]["departing_on"]).to_not eq trip_2.departing_on
            expect(trips[index]["destination_address"])
              .to_not eq trip_2.destination_address
          end
        end
      end

      context "when trying to view a different user's trips" do
        it "returns 403 Forbidden" do
          new_user = create(:user)

          get(
            api_v1_user_trips_url(new_user),
            headers: authorization_headers(current_user)
          )

          expect_user_forbidden_response
        end
      end

      context "not a real user id" do
        it "returns JSON with error" do
          get(
            api_v1_user_trips_url(user_id: "1"),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :not_found
          expect(parsed_body["errors"]).to eq "Couldn't find User with 'id'=1"
        end
      end
    end

    context "unauthenticated user" do
      let(:user) { create(:user) }

      context "no authorization header" do
        it "returns 401 Unauthorized" do
          get(
            api_v1_user_trips_url(user),
            headers: accept_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end

      context "invalid access token" do
        it "returns 401 Unauthorized" do
          get(
            api_v1_user_trips_url(user),
            headers: invalid_authorization_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end
end
