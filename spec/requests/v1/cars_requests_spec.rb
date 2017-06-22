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
        expect(body).to have_json_path("car/trip/code")
        expect(body).to have_json_path("car/trip/creator")
        expect(body).to have_json_path("car/trip/departing_on")
        expect(body).to have_json_path("car/trip/destination_address")
        expect(body).to have_json_path("car/trip/destination_latitude")
        expect(body).to have_json_path("car/trip/destination_longitude")
        expect(body).to have_json_path("car/trip/id")
        expect(body).to have_json_path("car/trip/name")

        expect(parsed_body["car"]["locations"]).to be_a(Array)
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

  describe "GET /cars/:id", type: :reqest do
    context "for a valid car" do
      xcontext "when user is signed in" do
        it "returns valid JSON for the car and its passengers" do
          current_user = create(:user) #there will be a helper method for this
          # implement "it" block from line 123 here when authorization is in effect
          # (change passenger to current_user)
        end

        context "the user isn't signed up for the car's associated trip " do
          it "returns 403 Forbidden" do
            current_user = create(:user) #there will be a helper method for this
            car = create(:car)

            expect {
              get(api_v1_car_url(car))
              expect(response).to have_http_status 403
            }.to raise_exception(NotAuthorizedError)
          end
        end
      end

      xcontext "when no user is signed in" do
        it "returns 403 Forbidden" do
          current_user = nil
          car = create(:car)
          passenger = create(:user)
          identity = create(:google_identity, user: passenger)
          signup = Signup.find_or_create_by(trip: car.trip, car: car, user: passenger)

          expect {
            get(api_v1_car_url(car))
            expect(response).to have_http_status 403
          }.to raise_exception(NotAuthorizedError)
        end
      end

      it "returns valid JSON for the car and its passengers" do
        car = create(:car)
        passenger = create(:user)
        identity = create(:google_identity, user: passenger)
        signup = Signup.find_or_create_by(trip: car.trip, car: car, user: passenger)

        get(api_v1_car_url(car))

        expect(response).to have_http_status :ok
        expect(body).to have_json_path("car")
        expect(body).to have_json_path("car/id")

        expect(parsed_body["car"]["max_seats"]).to eq(1)
        expect(parsed_body["car"]["name"]).to include("Car ")
        expect(parsed_body["car"]["status"]).to eq("not_started")

        expect(body).to have_json_path("car/trip")
        expect(body).to have_json_path("car/trip/code")
        expect(body).to have_json_path("car/trip/creator")
        expect(body).to have_json_path("car/trip/departing_on")
        expect(body).to have_json_path("car/trip/destination_address")
        expect(body).to have_json_path("car/trip/destination_latitude")
        expect(body).to have_json_path("car/trip/destination_longitude")
        expect(body).to have_json_path("car/trip/id")
        expect(body).to have_json_path("car/trip/name")

        expect(parsed_body["car"]["locations"]).to be_a(Array)
        expect(parsed_body["car"]["passengers"]).to be_a(Array)

        expect(body).to have_json_path("car/passengers/0/id")
        expect(body).to have_json_path("car/passengers/0/name")
        expect(body).to have_json_path("car/passengers/0/email")
      end
    end

    context "for a car that doesn't exist" do
      it "should raise an error" do
        expect {
          get(api_v1_car_url(id: 1))

          expect(response).to have_http_status 422
        }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end
