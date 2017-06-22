require "rails_helper"

RSpec.describe "POST /cars/:id/statuses", type: :request do
  context "user can update their car's status to reflect starting the trip" do
    context "when status is specified as a number" do
      it "returns updated JSON for the car" do
        car = create(:car)

        post(
        api_v1_car_statuses_url(car),
        params: { status: 1 }.to_json,
        headers: accept_headers
        )

        expect(response).to have_http_status :ok
        expect(body).to have_json_path("car")
        expect(body).to have_json_path("car/status")
        expect(parsed_body["car"]["status"]).to eq("in_transit")
      end
    end

    context "when status is specified as a string" do
      it "returns updated JSON for the car" do
        car = create(:car)

        post(
        api_v1_car_statuses_url(car),
        params: { status: "in_transit" }.to_json,
        headers: accept_headers
        )

        expect(response).to have_http_status :ok
        expect(body).to have_json_path("car")
        expect(body).to have_json_path("car/status")
        expect(parsed_body["car"]["status"]).to eq("in_transit")
      end
    end
  end

  context "user can update car's status to reflect arriving at the destination" do
    context "when status is specified as a number" do
      it "returns updated JSON for the car" do
        car = create(:car)

        post(
        api_v1_car_statuses_url(car),
        params: { status: 2 }.to_json,
        headers: accept_headers
        )

        expect(response).to have_http_status :ok
        expect(body).to have_json_path("car")
        expect(body).to have_json_path("car/status")
        expect(parsed_body["car"]["status"]).to eq("arrived")
      end
    end

    context "when status is specified as a string" do
      it "returns updated JSON for the car" do
        car = create(:car)

        post(
          api_v1_car_statuses_url(car),
          params: { status: "arrived" }.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status :ok
        expect(body).to have_json_path("car")
        expect(body).to have_json_path("car/status")
        expect(parsed_body["car"]["status"]).to eq("arrived")
      end
    end
  end
end
