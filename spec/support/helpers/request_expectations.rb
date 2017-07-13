module Helpers
  module RequestExpectations
    def expect_body_to_include_car_attributes(car, trip, user)
      expect(parsed_body["car"]["id"]).to eq(car.id)
      expect(parsed_body["car"]["max_seats"]).to eq(car.max_seats)
      expect(parsed_body["car"]["name"]).to eq(car.name)
      expect(parsed_body["car"]["seats_remaining"]).to eq(car.max_seats - car.users.count)
      expect(parsed_body["car"]["trip"]["id"]).to eq(trip.id)
      expect(parsed_body["car"]["trip"]["name"]).to eq(trip.name)
      expect(parsed_body["car"]["passengers"][0]["id"]).to eq(user.id)
      expect(parsed_body["car"]["passengers"][0]["name"]).to eq(user.name)
      expect(parsed_body["car"]["passengers"][0]["email"]).to eq(user.google_identity.email)
      expect(parsed_body["car"]["passengers"][0]["image"]).to eq(user.google_identity.image)
    end

    def expect_body_to_include_trip_locations_attributes_at_path(path)
      expect(body).to have_json_path("#{path}")
      expect(body).to have_json_path("#{path}/trip_id")
      expect(body).to have_json_path("#{path}/last_locations")
    end

    def expect_body_to_include_locations_attributes_at_path(path)
      expect(body).to have_json_path("#{path}/id")
      expect(body).to have_json_path("#{path}/car_id")
      expect(body).to have_json_path("#{path}/car_name")
      expect(body).to have_json_path("#{path}/direction")
      expect(body).to have_json_path("#{path}/latitude")
      expect(body).to have_json_path("#{path}/longitude")
    end

    def expect_body_to_include_locations_content(car, location, index)
      expect(parsed_body["trip_locations"]["last_locations"][index]["car_id"])
        .to eq(car.id)
      expect(parsed_body["trip_locations"]["last_locations"][index]["car_name"])
        .to eq(car.name)
      expect(parsed_body["trip_locations"]["last_locations"][index]["direction"])
        .to eq(location.direction)
      expect(parsed_body["trip_locations"]["last_locations"][index]["latitude"])
        .to eq(location.latitude.to_s)
      expect(parsed_body["trip_locations"]["last_locations"][index]["longitude"])
        .to eq(location.longitude.to_s)
      end

    def expect_response_to_include_basic_trip_attributes_at_path(path)
      expect(body).to have_json_path("#{path}")
      expect(body).to have_json_path("#{path}/code")
      expect(body).to have_json_path("#{path}/creator")
      expect(body).to have_json_path("#{path}/creator/name")
      expect(body).to have_json_path("#{path}/departing_on")
      expect(body).to have_json_path("#{path}/destination_address")
      expect(body).to have_json_path("#{path}/destination_latitude")
      expect(body).to have_json_path("#{path}/destination_longitude")
      expect(body).to have_json_path("#{path}/name")
    end

    def expect_response_to_include_complete_trip_attributes_at_path(path)
      expect_response_to_include_basic_trip_attributes_at_path(path)
      expect(body).to have_json_path("#{path}/cars")
    end

    def expect_response_to_include_trip_with_cars_attributes_at_path(path, num_cars)
      num_cars.times do |i|
        expect(body).to have_json_path("#{path}/#{i}/max_seats")
        expect(body).to have_json_path("#{path}/#{i}/name")
        expect(body).to have_json_path("#{path}/#{i}/owner_id")
        expect(body).to have_json_path("#{path}/#{i}/passengers")
        expect(body).to have_json_path("#{path}/#{i}/passengers/0/name")
        expect(body).to have_json_path("#{path}/#{i}/passengers/0/image")
        expect(body).to have_json_path("#{path}/#{i}/status")
      end
    end

    def expect_response_to_include_correct_trip_factory_content(creator)
      expect(parsed_body["trip"]["creator"]["name"]).to eq creator.name
      expect(parsed_body["trip"]["destination_address"])
        .to eq(attributes_for(:trip)[:destination_address].to_s)
      expect(parsed_body["trip"]["destination_latitude"])
        .to eq(attributes_for(:trip)[:destination_latitude].to_s)
      expect(parsed_body["trip"]["destination_longitude"])
        .to eq(attributes_for(:trip)[:destination_longitude].to_s)
    end

    def expect_body_to_include_car_attributes_at_path(path)
      expect(body).to have_json_path(path)
      expect(body).to have_json_path("#{path}/id")
      expect(body).to have_json_path("#{path}/locations")
      expect(body).to have_json_path("#{path}/max_seats")
      expect(body).to have_json_path("#{path}/name")
      expect(body).to have_json_path("#{path}/owner_id")
      expect(body).to have_json_path("#{path}/passengers")
      expect(body).to have_json_path("#{path}/seats_remaining")
      expect(body).to have_json_path("#{path}/status")
      expect_response_to_include_basic_trip_attributes_at_path("#{path}/trip")
    end

    def expect_body_to_include_passenger_attributes
      parsed_body["car"]["passengers"].first do |passenger|
        expect(passenger["id"]).to eq(current_user.id)
        expect(passenger["name"]).to eq(current_user.name)
        expect(passenger["email"]).to eq(google_identity.email)
        expect(passenger["image"]).to eq(google_identity.image)
      end
    end

    def expect_body_to_include_signup_attributes_and_content(user, trip)
      expect(body).to have_json_path("signup")
      expect(body).to have_json_path("signup/user_id")
      expect(body).to have_json_path("signup/trip_id")
      expect(parsed_body["signup"]["user_id"]).to eq(user.id)
      expect(parsed_body["signup"]["trip_id"]).to eq(trip.id)
    end

    def expect_user_forbidden_response
      expect(response).to have_http_status :forbidden
      expect(errors)
        .to include("User is not authorized to perform this action")
    end
  end
end
