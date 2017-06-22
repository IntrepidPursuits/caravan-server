require "rails_helper"

RSpec.describe "PATCH /cars/:id/status" do
  context "authenticated user" do
    let!(:current_user) { create(:user) }
    let!(:current_user_identity) { create(:google_identity, user: current_user) }

    context "user can update their car's status to reflect starting/ending the trip" do
      context "when status is specified as a valid number" do
        it "returns updated JSON for the car" do
          car = create(:car)
          create(:signup, car: car, trip: car.trip, user: current_user)

          patch(
            api_v1_car_status_url(car),
            params: { status: 1 }.to_json,
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :ok
          expect(body).to have_json_path("car")
          expect(body).to have_json_path("car/status")
          expect(parsed_body["car"]["status"]).to eq("in_transit")

          patch(
            api_v1_car_status_url(car),
            params: { status: 2 }.to_json,
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :ok
          expect(body).to have_json_path("car")
          expect(body).to have_json_path("car/status")
          expect(parsed_body["car"]["status"]).to eq("arrived")
        end
      end

      context "when status is specified as a valid string" do
        it "returns updated JSON for the car" do
          car = create(:car)
          create(:signup, car: car, trip: car.trip, user: current_user)

          patch(
            api_v1_car_status_url(car),
            params: { status: "in_transit" }.to_json,
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :ok
          expect(body).to have_json_path("car")
          expect(body).to have_json_path("car/status")
          expect(parsed_body["car"]["status"]).to eq("in_transit")

          patch(
            api_v1_car_status_url(car),
            params: { status: "arrived" }.to_json,
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :ok
          expect(body).to have_json_path("car")
          expect(body).to have_json_path("car/status")
          expect(parsed_body["car"]["status"]).to eq("arrived")
        end
      end

      context "user is not signed up for the trip" do
        it "returns 403 Forbidden" do
          car = create(:car)

          patch(
            api_v1_car_status_url(car),
            params: { status: "in_transit" }.to_json,
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :forbidden
          expect(parsed_body["errors"])
            .to include "User is not authorized to perform this action"
        end
      end

      context "user is signed up for the trip but not the car" do
        it "returns 403 Forbidden" do
          car = create(:car)
          create(:signup, trip: car.trip, user: current_user)

          patch(
            api_v1_car_status_url(car),
            params: { status: "in_transit" }.to_json,
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :forbidden
          expect(parsed_body["errors"])
            .to include "User is not authorized to perform this action"
        end
      end
    end

    context "with invalid status update" do
      it "raises an error" do
        car = create(:car)
        create(:signup, car: car, trip: car.trip, user: current_user)

        patch(
          api_v1_car_status_url(car),
          params: { status: "boogityboogityboo" }.to_json,
          headers: authorization_headers(current_user)
        )

        expect(response).to have_http_status :bad_request
        expect(parsed_body["errors"]).to eq "'boogityboogityboo' is not a valid status"

        patch(
          api_v1_car_status_url(car),
          params: { status: 42 }.to_json,
          headers: authorization_headers(current_user)
        )

        expect(response).to have_http_status :bad_request
        expect(parsed_body["errors"]).to eq "'42' is not a valid status"
      end
    end
  end

  context "unauthenticated user" do
    context "no authorization header" do
      it "returns 401 Unauthorized" do
        car = create(:car)

        patch(
          api_v1_car_status_url(car),
          params: { status: "in_transit" }.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status :unauthorized
      end
    end

    context "invalid access token" do
      it "returns 401 Unauthorized" do
        car = create(:car)

        patch(
          api_v1_car_status_url(car),
          params: { status: "in_transit" }.to_json,
          headers: invalid_authorization_headers
        )

        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
