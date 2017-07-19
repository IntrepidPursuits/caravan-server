class LocationSimulator
  attr_reader :car1_id,
              :car2_id,
              :owner1_token,
              :owner2_token,
              :stops_data

  def initialize
    @car1_id = SIMULATOR_CAR1_ID
    @car2_id = SIMULATOR_CAR2_ID
    @owner1_token = SIMULATOR_USER1_TOKEN
    @owner2_token = SIMULATOR_USER2_TOKEN
    @stops_data = build_stops_data
  end

  def self.reset_locations
    new.reset_locations
  end

  def self.perform
    new.perform
  end

  def perform
    reset_locations
    last_locations = ""
    stops_data.each do |stop|
      stop.each do |car|
        last_locations = add_location(car[:owner_token], car[:car_id], car[:location][:direction], car[:location][:latitude], car[:location][:longitude])
      end
      sleep SIMULATOR_SLEEP_INTERVAL
    end
    last_locations
  end

  def reset_locations
    print_resetting
    add_location(owner1_token, car1_id, 200, "42.367124", "-71.081569")
    add_location(owner2_token, car2_id, 190, "42.366565", "-71.077874")
  end

  def add_location(access_token, car_id, direction, latitude, longitude)
    url = URI("http://caravan-server-staging.herokuapp.com/api/v1/cars/#{car_id}/locations")
    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Post.new(url)
    request["accept"] = "application/vnd.caravan-server.com; version=1"
    request["content-type"] = "application/json"
    request["authorization"] = "Bearer #{access_token}"
    request.body = "{\n\"location\": {\n\"direction\": #{direction},\n\"latitude\": \"#{latitude}\",\n\"longitude\": \"#{longitude}\"\n}\n}"

    response = http.request(request)

    if response.code == "201"
      print_success(latitude, longitude, car_id)
    else
      print_failure(response)
    end

    response.read_body
  end

  def print_resetting
    puts "Resetting the car locations..."
  end

  def print_success(latitude, longitude, car_id)
    puts "Location added at #{latitude}, #{longitude} to car with id #{car_id}"
  end

  def print_failure(response)
    puts "Something went wrong: #{response.code} #{response.message}"
  end

  def build_stops_data
    stops_data = []
    SIMULATOR_LOCATION_DATA.each do |stop|
      stop_data = [
        {
          owner_token: "#{owner1_token}",
          car_id: "#{car1_id}",
          location: {
            direction: stop[0][:direction],
            latitude: stop[0][:latitude],
            longitude: stop[0][:longitude]
          }
        },
        {
          owner_token: "#{owner2_token}",
          car_id: "#{car2_id}",
          location: {
            direction: stop[1][:direction],
            latitude: stop[1][:latitude],
            longitude: stop[1][:longitude]
          }
        }
      ]
      stops_data << stop_data
    end
    stops_data
  end
end
