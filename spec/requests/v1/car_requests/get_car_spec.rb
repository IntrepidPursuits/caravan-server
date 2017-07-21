require "rails_helper"

describe "Car Requests" do
  describe "GET /cars/:id" do
    context "authenticated user" do
      let(:current_user) { create(:user) }

      context "for a valid car" do
        it "returns valid JSON for the car and its passengers" do
          car = create(:car, max_seats: 2)
          passenger1 = create(:user)
          passenger2 = create(:user)
          google_identity = create(:google_identity, user: passenger1, image: "googlepic")
          twitter_identity = create(:twitter_identity, user: passenger2, image: "twitterpic")
          _signup1 = Signup.find_or_create_by(trip: car.trip, car: car, user: passenger1)
          _signup2 = Signup.find_or_create_by(trip: car.trip, car: car, user: passenger2)

          get(
            api_v1_car_url(car),
            headers: authorization_headers(passenger1)
          )

          expect(response).to have_http_status :ok
          expect(body).to have_json_path("car")

          expect(json_value_at_path("car/id")).to eq(car.id)
          expect(json_value_at_path("car/max_seats")).to eq(2)
          expect(json_value_at_path("car/name")).to eq(car.name)
          expect(json_value_at_path("car/owner_id")).to eq(car.owner_id)
          expect(json_value_at_path("car/seats_remaining")).to eq(0)
          expect(json_value_at_path("car/status")).to eq("not_started")
          expect(json_value_at_path("car/locations")).to be_a(Array)
          expect(json_value_at_path("car/passengers")).to be_a(Array)
          expect(json_value_at_path("car/passengers/0/id")).to eq(passenger1.id)
          expect(json_value_at_path("car/passengers/0/name")).to eq(passenger1.name)
          expect(json_value_at_path("car/passengers/0/email")).to eq(google_identity.email)
          expect(json_value_at_path("car/passengers/0/image")).to eq(google_identity.image)
          expect(json_value_at_path("car/passengers/1/id")).to eq(passenger2.id)
          expect(json_value_at_path("car/passengers/1/name")).to eq(passenger2.name)
          expect(json_value_at_path("car/passengers/1/email")).to eq(nil)
          expect(json_value_at_path("car/passengers/1/image")).to eq(twitter_identity.image)
        end
      end

      context "the user isn't signed up for the car's associated trip" do
        it "returns 403 Forbidden" do
          car = create(:car)

          get(
            api_v1_car_url(car),
            headers: authorization_headers(current_user)
          )

          expect_user_forbidden_response
        end
      end

      context "for a car that doesn't exist" do
        it "should raise an error" do
          get(
            api_v1_car_url(id: 1),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :not_found
          expect(errors).to include("Couldn't find Car with 'id'=1")
        end
      end
    end

    context "unauthenticated user" do
      context "no authorization header" do
        it "returns 401 Unauthorized" do
          car = create(:car)

          get(
            api_v1_car_url(car),
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
            headers: invalid_authorization_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end
end
