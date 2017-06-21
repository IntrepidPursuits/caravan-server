require "rails_helper"

RSpec.describe "Car Requests", type: :request do
  describe "POST /cars" do
    context "with valid trip, max_seats, name, status, and associated signup(s)" do
      it "returns valid JSON for the new car" do
        unsaved_car = build(:car)
        valid_car_info = {
          car: unsaved_car
        }

        post(
          api_v1_cars_url,
          params: valid_car_info.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status :created
        expect(body).to have_json_path("car")
        expect(body).to have_json_path("car/id")

        expect(parsed_body["car"]["max_seats"]).to eq(1)
        expect(parsed_body["car"]["name"]).to include("Car ")
        expect(parsed_body["car"]["status"]).to eq("not_started")

        expect(body).to have_json_path("car/trip")
        expect(body).to have_json_path("car/trip/creator")
        expect(body).to have_json_path("car/trip/departing_on")
        expect(body).to have_json_path("car/trip/destination_address")
        expect(body).to have_json_path("car/trip/destination_latitude")
        expect(body).to have_json_path("car/trip/destination_longitude")
        expect(body).to have_json_path("car/trip/name")
        expect(body).to have_json_path("car/trip/invite_code")
        expect(body).to have_json_path("car/trip/signed_up_users")

        expect(parsed_body["car"]["passengers"]).to be_a(Array)
      end
    end

    context "with invalid info" do
      it "raises an error" do
        invalid_car_info = {
          car: {
            trip: nil,
            max_seats: nil,
            name: nil,
            status: nil
          }
        }

        post(
          api_v1_cars_url,
          params: invalid_car_info.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status :unprocessable_entity
        expect(body).to have_json_path("errors")
        expect(parsed_body["errors"]).to include "Trip must exist"
        expect(parsed_body["errors"]).to include "Trip can't be blank"
        expect(parsed_body["errors"]).to include "Max seats can't be blank"
        expect(parsed_body["errors"]).to include "Max seats is not a number"
        expect(parsed_body["errors"]).to include "Name can't be blank"
        expect(parsed_body["errors"]).to include "Status can't be blank"
      end
    end

    context "with no information" do
      it "raises an error" do
        empty_car_info = { car: {} }

        expect {
          post(
            api_v1_cars_url,
            params: empty_car_info.to_json,
            headers: accept_headers
          )

          expect(response).to have_http_status 400
          
        }.to raise_exception(ActionController::ParameterMissing, "param is missing or the value is empty: car")
      end
    end
  end
end
