require "rails_helper"

describe "Location Request" do
  describe "POST /cars/:car_id/locations" do
    context "authenticated user" do
      let(:current_user) { create(:user) }

      context "user owns the car and is signed up for it" do
        let!(:car) { create(:car, status: 1, owner: current_user) }
        let!(:signup) { create(:signup, car: car, trip: car.trip, user: current_user) }

        context "with valid attributes more than 0.1 miles from trip's destination" do
          it "creates the location returns valid JSON and car's status stays the same" do
            unsaved_location = build(:location, car: nil)
            valid_location_info = { location: unsaved_location }

            post(
              car_locations_url(car),
              params: valid_location_info.to_json,
              headers: authorization_headers(current_user)
            )

            car.reload
            expect(car.status).to eq("in_transit")

            expect(response).to have_http_status :created
            expect_body_to_include_trip_locations_attributes_at_path("trip_locations")
            expect_body_to_include_locations_attributes_at_path("trip_locations/last_locations/0")

            location = Location.find(json_value_at_path("trip_locations/last_locations/0/id"))
            expect(location).to be

            expect(json_value_at_path("trip_locations/trip_id")).to eq(car.trip.id)
            expect(json_value_at_path("trip_locations/last_locations/0/car_id"))
            .to eq(car.id)
            expect(json_value_at_path("trip_locations/last_locations/0/car_name"))
            .to eq(car.name)
            expect(json_value_at_path("trip_locations/last_locations/0/direction"))
            .to eq(attributes_for(:location)[:direction])
            expect(json_value_at_path("trip_locations/last_locations/0/latitude"))
            .to eq(attributes_for(:location)[:latitude].to_s)
            expect(json_value_at_path("trip_locations/last_locations/0/longitude"))
            .to eq(attributes_for(:location)[:longitude].to_s)
          end
        end

        context "with valid attributes within 0.1 miles of the trip's destination" do
          it "creates the location and changes the car's status to arrived" do
            unsaved_location = build(:location, car: nil, latitude: "42.366137", longitude: "-71.0784625")
            valid_location_info = { location: unsaved_location }

            post(
              car_locations_url(car),
              params: valid_location_info.to_json,
              headers: authorization_headers(current_user)
            )

            car.reload
            expect(car.status).to eq("arrived")

            expect(response).to have_http_status :created
            expect_body_to_include_trip_locations_attributes_at_path("trip_locations")
            expect_body_to_include_locations_attributes_at_path("trip_locations/last_locations/0")

            location = Location.find(json_value_at_path("trip_locations/last_locations/0/id"))
            expect(location).to be

            expect(json_value_at_path("trip_locations/trip_id")).to eq(car.trip.id)
            expect(json_value_at_path("trip_locations/last_locations/0/car_id"))
            .to eq(car.id)
            expect(json_value_at_path("trip_locations/last_locations/0/car_name"))
            .to eq(car.name)
            expect(json_value_at_path("trip_locations/last_locations/0/direction"))
            .to eq(attributes_for(:location)[:direction])
            expect(json_value_at_path("trip_locations/last_locations/0/latitude"))
            .to eq("42.366137")
            expect(json_value_at_path("trip_locations/last_locations/0/longitude"))
            .to eq("-71.0784625")
          end
        end

        context "with no direction specified" do
          it "defaults direction to zero and returns 201 created" do
            invalid_location_info = {
              location: {
                latitude: 12.0,
                longitude: -36.5
              }
            }

            post(
              car_locations_url(car),
              params: invalid_location_info.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :created
            expect_body_to_include_trip_locations_attributes_at_path("trip_locations")
            expect_body_to_include_locations_attributes_at_path("trip_locations/last_locations/0")

            location = Location.find(json_value_at_path("trip_locations/last_locations/0/id"))
            expect(location).to be
            expect(location.direction).to eq(0)
          end
        end

        context "with all invalid attributes" do
          it "returns JSON with validation errors" do
            invalid_location_info = {
              location: {
                direction: nil,
                latitude: nil,
                longitude: nil
              }
            }

            post(
              car_locations_url(car),
              params: invalid_location_info.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :unprocessable_entity
            expect(body).to have_json_path("errors")
            expect(errors).to include("Validation failed")
            expect(errors).to include("Latitude can't be blank")
            expect(errors).to include("Longitude can't be blank")
            expect(errors).to include("Direction is not a number")
            expect(errors).to include("Direction can't be blank")
          end
        end

        context "with invalid latitude and longitude, but valid direction" do
          it "returns JSON with validation errors" do
            invalid_location_info = {
              location: {
                direction: -2,
                latitude: nil,
                longitude: nil
              }
            }

            post(
              car_locations_url(car),
              params: invalid_location_info.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :unprocessable_entity
            expect(body).to have_json_path("errors")
            expect(errors).to include("Validation failed")
            expect(errors).to include("Latitude can't be blank")
            expect(errors).to include("Longitude can't be blank")
          end
        end

        context "with invalid direction" do
          context "with nil direction" do
            it "returns validation errors" do
              invalid_location_info = {
                location: {
                  direction: nil,
                  latitude: 1.4,
                  longitude: -70.3
                }
              }

              post(
                car_locations_url(car),
                params: invalid_location_info.to_json,
                headers: authorization_headers(current_user)
              )

              expect(response).to have_http_status :unprocessable_entity
              expect(errors).to include("Validation failed")
              expect(errors).to include("Direction is not a number")
              expect(errors).to include("Direction can't be blank")
            end
          end

          context "with a number outside the range" do
            it "returns validation errors" do
              invalid_location_info = {
                location: {
                  direction: -10,
                  latitude: 1.4,
                  longitude: -70.3
                }
              }

              post(
                car_locations_url(car),
                params: invalid_location_info.to_json,
                headers: authorization_headers(current_user)
              )

              expect(response).to have_http_status :unprocessable_entity
              expect(errors).to include("Validation failed")
              expect(errors).to include("Direction must be greater than or equal to 0")


              invalid_location_info = {
                location: {
                  direction: 370,
                  latitude: 1.4,
                  longitude: -70.3
                }
              }

              post(
                car_locations_url(car),
                params: invalid_location_info.to_json,
                headers: authorization_headers(current_user)
              )

              expect(response).to have_http_status :unprocessable_entity
              expect(errors).to include("Validation failed")
              expect(errors).to include("Direction must be less than or equal to 360")
            end
          end

          context "with a decimal" do
            it "returns validation errors" do
              invalid_location_info = {
                location: {
                  direction: 19.3,
                  latitude: 1.4,
                  longitude: -70.3
                }
              }

              post(
                car_locations_url(car),
                params: invalid_location_info.to_json,
                headers: authorization_headers(current_user)
              )

              expect(response).to have_http_status :unprocessable_entity
              expect(errors).to include("Validation failed")
              expect(errors).to include("Direction must be an integer")
            end
          end
        end

        context "with car that hasn't started trip yet" do
          it "returns JSON with validation errors" do
            car = create(:car, owner: current_user)
            signup = create(:signup, car: car, trip: car.trip, user: current_user)
            unsaved_location = build(:location, car: nil)
            valid_location_info = { location: unsaved_location }

            post(
              car_locations_url(car),
              params: valid_location_info.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :unprocessable_entity
            expect(body).to have_json_path("errors")
            expect(errors)
              .to include("Cannot update car's location unless it has a status of 'In Transit'")
          end
        end

        context "with car that has arrived at its destination" do
          it "returns JSON with validation errors" do
            car = create(:car, owner: current_user, status: 2)
            signup = create(:signup, car: car, trip: car.trip, user: current_user)
            unsaved_location = build(:location, car: nil)
            valid_location_info = { location: unsaved_location }

            post(
              car_locations_url(car),
              params: valid_location_info.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :unprocessable_entity
            expect(body).to have_json_path("errors")
            expect(errors)
              .to include("Cannot update car's location unless it has a status of 'In Transit'")
          end
        end

        context "with an invalid car_id" do
          it "returns 404 Not Found" do
            unsaved_location = build(:location, car: car)
            valid_location_info = { location: unsaved_location }

            post(
              car_locations_url("Baby You Can Drive My Car"),
              params: valid_location_info.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :not_found
            expect(errors).to eq("Couldn't find Car with 'id'=Baby You Can Drive My Car")
          end
        end

        context "user tried to signed up for the car but not the trip/car belongs to different trip" do
          it "returns 403 Forbidden" do
            car = create(:car, status: 1, owner: current_user)
            trip = create(:trip)

            expect{ create(:signup, car: car, user: current_user) }
              .to raise_error(ActiveRecord::RecordInvalid)

            unsaved_location = build(:location, car: car)
            valid_location_info = { location: unsaved_location }

            post(
              car_locations_url(car),
              params: valid_location_info.to_json,
              headers: authorization_headers(current_user)
            )

            expect_user_forbidden_response
          end
        end
      end

      context "user is signed up for the car but doesn't own it" do
        let!(:car) { create(:car, status: 1) }
        let!(:signup) { create(:signup, car: car, trip: car.trip, user: current_user) }

        context "with valid attributes" do
          context "no other locations for the car or the trip" do
            it "doesn't create the location, returns empty list of last locations" do
              unsaved_location = build(:location, car: nil)
              valid_location_info = { location: unsaved_location }
              location_count = Location.count

              post(
                car_locations_url(car),
                params: valid_location_info.to_json,
                headers: authorization_headers(current_user)
              )

              expect(response).to have_http_status :ok
              expect(Location.count).to eq(location_count)
              expect_body_to_include_trip_locations_attributes_at_path("trip_locations")
              expect(json_value_at_path("trip_locations/last_locations")).to eq([])
              expect(json_value_at_path("trip_locations/trip_id")).to eq(car.trip.id)
            end
          end

          context "other locations for the car or the trip" do
            it "doesn't create the location, returns locations of cars in the trip" do
              location = create(:location, car: car, direction: 1, latitude: 2.0, longitude: 3.0)
              unsaved_location = build(:location, car: nil)
              valid_location_info = { location: unsaved_location }
              location_count = Location.count

              post(
                car_locations_url(car),
                params: valid_location_info.to_json,
                headers: authorization_headers(current_user)
              )

              expect(response).to have_http_status :ok
              expect(Location.count).to eq(location_count)
              expect_body_to_include_trip_locations_attributes_at_path("trip_locations")
              expect_body_to_include_locations_attributes_at_path("trip_locations/last_locations/0")
              expect(json_value_at_path("trip_locations/last_locations").length).to eq(1)
              expect(json_value_at_path("trip_locations/trip_id")).to eq(car.trip.id)
              expect(json_value_at_path("trip_locations/last_locations/0/direction")).to eq(1)
              expect(json_value_at_path("trip_locations/last_locations/0/latitude")).to eq("2.0")
              expect(json_value_at_path("trip_locations/last_locations/0/longitude")).to eq("3.0")
            end
          end
        end

        context "no direction specified" do
          it "doesn't create the location, returns valid JSON" do
            location_count = Location.count
            invalid_location_info = {
              location: {
                latitude: 12.0,
                longitude: -36.5
              }
            }

            post(
              car_locations_url(car),
              params: invalid_location_info.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :ok
            expect(Location.count).to eq(location_count)
            expect_body_to_include_trip_locations_attributes_at_path("trip_locations")
            expect(json_value_at_path("trip_locations/last_locations")).to eq([])
            expect(json_value_at_path("trip_locations/trip_id")).to eq(car.trip.id)
          end
        end

        context "with all invalid attributes" do
          it "doesn't create the location, returns valid JSON" do
            location_count = Location.count
            invalid_location_info = {
              location: {
                direction: nil,
                latitude: nil,
                longitude: nil
              }
            }

            post(
              car_locations_url(car),
              params: invalid_location_info.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :ok
            expect(Location.count).to eq(location_count)
            expect_body_to_include_trip_locations_attributes_at_path("trip_locations")
            expect(json_value_at_path("trip_locations/last_locations")).to eq([])
            expect(json_value_at_path("trip_locations/trip_id")).to eq(car.trip.id)
          end
        end

        context "with invalid latitude and longitude, but valid direction" do
          it "doesn't create the location, returns valid JSON" do
            location_count = Location.count
            invalid_location_info = {
              location: {
                direction: 270,
                latitude: nil,
                longitude: nil
              }
            }

            post(
              car_locations_url(car),
              params: invalid_location_info.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :ok
            expect(Location.count).to eq(location_count)
            expect_body_to_include_trip_locations_attributes_at_path("trip_locations")
            expect(json_value_at_path("trip_locations/last_locations")).to eq([])
            expect(json_value_at_path("trip_locations/trip_id")).to eq(car.trip.id)
          end
        end

        context "with invalid direction" do
          it "doesn't create the location, returns valid JSON" do
            location_count = Location.count
            invalid_location_info = {
              location: {
                direction: nil,
                latitude: 1.4,
                longitude: -70.3
              }
            }

            post(
              car_locations_url(car),
              params: invalid_location_info.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :ok
            expect(Location.count).to eq(location_count)
            expect_body_to_include_trip_locations_attributes_at_path("trip_locations")
            expect(json_value_at_path("trip_locations/last_locations")).to eq([])
            expect(json_value_at_path("trip_locations/trip_id")).to eq(car.trip.id)
          end
        end

        context "car hasn't started the trip yet" do
          it "returns JSON with validation errors" do
            location_count = Location.count
            car = create(:car)
            signup = create(:signup, car: car, trip: car.trip, user: current_user)
            unsaved_location = build(:location, car: nil)
            valid_location_info = { location: unsaved_location }

            post(
              car_locations_url(car),
              params: valid_location_info.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :unprocessable_entity
            expect(Location.count).to eq(location_count)
            expect(body).to have_json_path("errors")
            expect(errors)
              .to include("Cannot update car's location unless it has a status of 'In Transit'")
          end
        end

        context "car has already arrived at its destination" do
          it "returns JSON with validation errors" do
            location_count = Location.count
            car = create(:car, status: 2)
            signup = create(:signup, car: car, trip: car.trip, user: current_user)
            unsaved_location = build(:location, car: nil)
            valid_location_info = { location: unsaved_location }

            post(
              car_locations_url(car),
              params: valid_location_info.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :unprocessable_entity
            expect(Location.count).to eq(location_count)
            expect(body).to have_json_path("errors")
            expect(errors)
              .to include("Cannot update car's location unless it has a status of 'In Transit'")
          end
        end

        context "with an invalid car_id" do
          it "returns 404 Not Found" do
            unsaved_location = build(:location, car: car)
            valid_location_info = { location: unsaved_location }

            post(
              car_locations_url("Baby You Can Drive My Car"),
              params: valid_location_info.to_json,
              headers: authorization_headers(current_user)
            )

            expect(response).to have_http_status :not_found
            expect(errors).to eq("Couldn't find Car with 'id'=Baby You Can Drive My Car")
          end
        end
      end

      context "user is not signed up for the trip or the car" do
        it "returns 403 Forbidden" do
          car = create(:car, status: 1)
          unsaved_location = build(:location, car: car)
          valid_location_info = { location: unsaved_location }

          post(
            car_locations_url(car),
            params: valid_location_info.to_json,
            headers: authorization_headers(current_user)
          )

          expect_user_forbidden_response
        end
      end

      context "user is signed up for trip but not in the car" do
        it "returns 403 Forbidden" do
          car = create(:car, status: 1)
          signup = create(:signup, trip: car.trip, user: current_user)
          unsaved_location = build(:location, car: nil)
          valid_location_info = { location: unsaved_location }

          post(
            car_locations_url(car),
            params: valid_location_info.to_json,
            headers: authorization_headers(current_user)
          )

          expect_user_forbidden_response
        end
      end
    end

    context "unauthenticated user" do
      context "no authorization header" do
        it "returns 401 Unauthorized" do
          car = create(:car)
          unsaved_location = build(:location, car: nil)
          valid_location_info = { location: unsaved_location }

          post(
            car_locations_url(car),
            params: valid_location_info.to_json,
            headers: accept_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end

      context "invalid access token" do
        it "returns 401 Unauthorized" do
          car = create(:car)
          unsaved_location = build(:location, car: nil)
          valid_location_info = { location: unsaved_location }

          post(
            car_locations_url(car),
            params: valid_location_info.to_json,
            headers: invalid_authorization_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end
end
