class DemoLocations
  attr_reader :car1_id,
              :car2_id,
              :owner1_token,
              :owner2_token,
              :stops_data

  def initialize
    @car1_id = "797b99d0-9984-4302-9b7a-c5a8b32a8153"
    @car2_id = "1a31a607-1bcc-46b3-98e0-b125c36d52eb"
    @owner1_token = DEMO_USER1_TOKEN
    @owner2_token = DEMO_USER2_TOKEN
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
    stops_data.each do |stop|
      stop.each do |car|
        add_location(car[:owner_token], car[:car_id], car[:location][:latitude], car[:location][:longitude])
      end
      sleep 5
    end
    return
  end

  def reset_locations
    puts "Resetting the car locations..."
    add_location(owner1_token, car1_id, "42.367124", "-71.081569")
    add_location(owner2_token, car2_id, "42.366565", "-71.077874")
  end

  def add_location(access_token, car_id, latitude, longitude)
    url = URI("http://caravan-server-staging.herokuapp.com/api/v1/cars/#{car_id}/locations")
    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Post.new(url)
    request["accept"] = "application/vnd.caravan-server.com; version=1"
    request["content-type"] = "application/json"
    request["authorization"] = "Bearer #{access_token}"
    request.body = "{\n\"location\": {\n\"latitude\": \"#{latitude}\",\n\"longitude\": \"#{longitude}\"\n}\n}"

    http.request(request)
    puts "Location added at #{latitude}, #{longitude} to car with id #{car_id}"
  end

  def build_stops_data
    stops_data = []
    location_data.each do |stop|
      stop_data = [
        {
          owner_token: "#{owner1_token}",
          car_id: "#{car1_id}",
          location: {
            latitude: stop[0],
            longitude: stop[1]
          }
        },
        {
          owner_token: "#{owner2_token}",
          car_id: "#{car2_id}",
          location: {
            latitude: stop[2],
            longitude: stop[3]
          }
        }
      ]
      stops_data << stop_data
    end
    stops_data
  end

  def location_data
    [
      ["42.364683", "-71.083040", "42.363067", "-71.078764"],
      ["42.362498", "-71.084160", "42.360616", "-71.083341"],
      ["42.361474", "-71.076280", "42.357998", "-71.090608"],
      ["42.359123", "-71.072217", "42.355932", "-71.096740"]
    ]
  end
end
