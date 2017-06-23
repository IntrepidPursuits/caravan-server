require "rails_helper"

RSpec.describe "PATCH /cars/:id/status", type: :request do
  context "user can update their car's status to reflect starting/ending the trip" do
    context "when status is specified as a valid number" do
      it "returns updated JSON for the car" do
        car = create(:car)

        patch(
          api_v1_car_status_url(car),
          params: { status: 1 }.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status :ok
        expect(body).to have_json_path("car")
        expect(body).to have_json_path("car/status")
        expect(parsed_body["car"]["status"]).to eq("in_transit")

        patch(
        api_v1_car_status_url(car),
        params: { status: 2 }.to_json,
        headers: accept_headers
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

        patch(
          api_v1_car_status_url(car),
          params: { status: "in_transit" }.to_json,
          headers: accept_headers
        )

        expect(response).to have_http_status :ok
        expect(body).to have_json_path("car")
        expect(body).to have_json_path("car/status")
        expect(parsed_body["car"]["status"]).to eq("in_transit")

        patch(
          api_v1_car_status_url(car),
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

  context "with invalid status update" do
    it "raises an error" do
      car = create(:car)

      patch(
        api_v1_car_status_url(car),
        params: { status: "boogityboogityboo" }.to_json,
        headers: accept_headers
      )

      expect(response).to have_http_status :bad_request
      expect(parsed_body["errors"]).to eq "'boogityboogityboo' is not a valid status"

      patch(
        api_v1_car_status_url(car),
        params: { status: 42 }.to_json,
        headers: accept_headers
      )

      expect(response).to have_http_status :bad_request
      expect(parsed_body["errors"]).to eq "'42' is not a valid status"
    end
  end

  xcontext "when user is logged in" do
    before :each do
      current_user = create(:user)
    end

    xcontext "user is signed up for the car" do
      it "works" do
        Signup.find_or_create_by(trip: car.trip, car: car, user: current_user)
        # implement above tests in here
      end
    end

    xcontext "user is not signed up for the car" do
      it "raises an error" do
        car = create(:car)

        expect {
          patch(
            api_v1_car_status_url(car),
            params: { status: "in_transit" }.to_json,
            headers: accept_headers
          )
          expect(response).to have_http_status :unauthorized
        }.to raise_exception(NotAuthorizedError)
      end
    end
  end

  xcontext "when no user is logged in" do
    it "raises an error" do
      car = create(:car)

      expect {
        patch(
          api_v1_car_status_url(car),
          params: { status: "in_transit" }.to_json,
          headers: accept_headers
        )
        expect(response).to have_http_status 403
      }.to raise_exception(NotAuthorizedError)
    end
  end
end
