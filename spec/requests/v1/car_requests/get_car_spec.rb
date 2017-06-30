require "rails_helper"

describe "Car Requests" do
  describe "GET /cars/:id" do
    context "authenticated user" do
      let(:current_user) { create(:user) }

      context "for a valid car" do
        it "returns valid JSON for the car and its passengers" do
          car = create(:car)
          passenger = create(:user)
          identity = create(:google_identity, user: passenger)
          signup = Signup.find_or_create_by(trip: car.trip, car: car, user: passenger)

          get(
            api_v1_car_url(car),
            params: {},
            headers: authorization_headers(passenger)
          )

          expect(response).to have_http_status :ok
          expect(body).to have_json_path("car")
          expect(body).to have_json_path("car/id")

          expect(json_value_at_path("car/max_seats")).to eq(1)
          expect(json_value_at_path("car/name")).to include("Car ")
          expect(json_value_at_path("car/status")).to eq("not_started")

          expect(body).to have_json_path("car/trip")
          expect(body).to have_json_path("car/trip/code")
          expect(body).to have_json_path("car/trip/creator")
          expect(body).to have_json_path("car/trip/departing_on")
          expect(body).to have_json_path("car/trip/destination_address")
          expect(body).to have_json_path("car/trip/destination_latitude")
          expect(body).to have_json_path("car/trip/destination_longitude")
          expect(body).to have_json_path("car/trip/id")
          expect(body).to have_json_path("car/trip/name")

          expect(json_value_at_path("car/locations")).to be_a(Array)
          expect(json_value_at_path("car/passengers")).to be_a(Array)

          expect(body).to have_json_path("car/passengers/0/id")
          expect(body).to have_json_path("car/passengers/0/name")
          expect(body).to have_json_path("car/passengers/0/email")
        end
      end

      context "the user isn't signed up for the car's associated trip" do
        it "returns 403 Forbidden" do
          car = create(:car)

          get(
            api_v1_car_url(car),
            params: {},
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :forbidden
          expect(parsed_body["errors"])
            .to include "User is not authorized to perform this action"
        end
      end

      context "for a car that doesn't exist" do
        it "should raise an error" do
          get(
            api_v1_car_url(id: 1),
            params: {},
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :not_found
          expect(parsed_body["errors"]).to include "Couldn't find Car with 'id'=1"
        end
      end
    end

    context "unauthenticated user" do
      context "no authorization header" do
        it "returns 401 Unauthorized" do
          car = create(:car)

          get(
            api_v1_car_url(car),
            params: {},
            headers: accept_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end

      context "invalid access token" do
        it "returns 401 Unauthorized" do
          car = create(:car)

          get(
            api_v1_car_url(car),
            params: {},
            headers: invalid_authorization_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end
end
