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
        expect(body).to have_json_path("car/max_seats")
        expect(body).to have_json_path("car/name")
        expect(body).to have_json_path("car/status")
        expect(body).to have_json_path("car/trip")
        expect(body).to have_json_path("car/passengers")
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
        }.to raise_error ActionController::ParameterMissing
      end
    end
  end
end
