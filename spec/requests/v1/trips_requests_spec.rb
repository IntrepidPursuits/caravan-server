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

      get(api_v1_trip_url(trip))

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

  describe "GET /users/:user_id/trips" do
    let!(:current_user) { create(:user) }

    context "when user is signed in" do
      context "when the user is not yet signed up for any trips" do
        it "shows and empty array" do
          get(api_v1_user_trips_url(user_id: current_user.id))

          expect(response).to have_http_status :ok
          expect(parsed_body["trips"]).to be_a(Array)
          expect(parsed_body["trips"]).to eq []
        end
      end
    end

      context "when the user is signed up for at least one trip" do
        let!(:trip) { create(:trip) }
        let!(:signups) { create(:signup, user: current_user, trip: trip) }

        it "shows JSON for all the current user's trips" do
          get(api_v1_user_trips_url(user_id: current_user.id))

          expect(response).to have_http_status :ok
          expect(parsed_body["trips"]).to be_a(Array)
          expect(parsed_body["trips"][0]["code"]).to eq(trip.invite_code.code)
          expect(parsed_body["trips"][0]["departing_on"]).to match(trip.departing_on)
          expect(parsed_body["trips"][0]["destination_address"]).to eq("1 Sesame St")
          expect(parsed_body["trips"][0]["destination_latitude"]).to eq("1.0")
          expect(parsed_body["trips"][0]["destination_longitude"]).to eq("1.0")
          expect(parsed_body["trips"][0]["id"]).to eq(trip.id)
          expect(parsed_body["trips"][0]["name"]).to eq(trip.name)
        end
      end


    xcontext "when trying to view a different user's trips" do
      it "raises an error" do
        new_user = create(:user)

        get(api_v1_user_trips_url(user_id: new_user.id))
        expect(response).to have_http_status :forbidden
      end
    end

    xcontext "when trying to view trips for a user that doesn't exist" do
      it "raises an error" do
        get(api_v1_user_trips_url(user_id: "not a real user id"))

        expect(response).to have_http_status :not_found
        expect(parsed_body["errors"]).to eq "Couldn't find User with 'id'=not a real user id"
      end
    end

    xcontext "when no user is signed in" do
      it "raises an error" do
        user = current_user
        warden.logout
        get(api_v1_user_trips_url(user_id: user.id))

        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
