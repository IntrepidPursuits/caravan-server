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
    last_locations = ""
    stops_data.each do |stop|
      stop.each do |car|
        last_locations = add_location(car[:owner_token], car[:car_id], car[:location][:direction], car[:location][:latitude], car[:location][:longitude])
      end
      sleep 1
    end
    last_locations
  end

  def reset_locations
    puts "Resetting the car locations..."
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
      puts "Location added at #{latitude}, #{longitude} to car with id #{car_id}"
    else
      puts "Something went wrong: #{response.code} #{response.message}"
    end

    response.read_body
  end

  def build_stops_data
    stops_data = []
    location_data.each do |stop|
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

  def location_data
    [
      [
        {
          direction: 200,
          latitude: "42.364683",
          longitude: "-71.083040"
        },
        {
          direction: 190,
          latitude: "42.363067",
          longitude: "-71.078764"
        }
      ],
      [
        {
          direction: 130,
          latitude: "42.362498",
          longitude: "-71.084160"
        },
        {
          direction: 250,
          latitude: "42.360616",
          longitude: "-71.083341"
        }
      ],
      [
        {
          direction: 100,
          latitude: "42.361474",
          longitude: "-71.076280"
        },
        {
          direction: 250,
          latitude: "42.357998",
          longitude: "-71.090608"
        }
      ],
      [
        {
          direction: 190,
          latitude: "42.359123",
          longitude: "-71.072217"
        },
        {
          direction: 250,
          latitude: "42.355932",
          longitude: "-71.096740"
        }
      ],
      [
        {
          direction: 250,
          latitude: "42.355797",
          longitude: "-71.074772"
        },
        {
          direction: 250,
          latitude: "42.354830",
          longitude: "-71.100151"
        }
      ],
      [
        {
          direction: 250,
          latitude: "42.354491",
          longitude: "-71.079017"
        },
        {
          direction: 260,
          latitude: "42.353647",
          longitude: "-71.104212"
        }
      ],
      [
        {
          direction: 250,
          latitude: "42.353107",
          longitude: "-71.084177"
        },
        {
          direction: 300,
          latitude: "42.353935",
          longitude: "-71.110029"
        }
      ],
      [
        {
          direction: 260,
          latitude: "42.351677",
          longitude: "-71.092166"
        },
        {
          direction: 300,
          latitude: "42.355637",
          longitude: "-71.113309"
        }
      ],
      [
        {
          direction: 180,
          latitude: "42.349419",
          longitude: "-71.092886"
        },
        {
          direction: 350,
          latitude: "42.357495",
          longitude: "-71.115209"
        }
      ],
      [
        {
          direction: 270,
          latitude: "42.347937",
          longitude: "-71.094185"
        },
        {
          direction: 350,
          latitude: "42.359015",
          longitude: "-71.115635"
        }
      ],
      [
        {
          direction: 270,
          latitude: "42.347895",
          longitude: "-71.096820"
        },
        {
          direction: 350,
          latitude: "42.360764",
          longitude: "-71.115888"
        }
      ],
      [
        {
          direction: 275,
          latitude: "42.347895",
          longitude: "-71.100181"
        },
        {
          direction: 265,
          latitude: "42.360864",
          longitude: "-71.118081"
        }
      ],
      [
        {
          direction: 290,
          latitude: "42.348248",
          longitude: "-71.102377"
        },
        {
          direction: 230,
          latitude: "42.359990",
          longitude: "-71.121535"
        }
      ],
      [
        {
          direction: 295,
          latitude: "42.348714",
          longitude: "-71.105070"
        },
        {
          direction: 250,
          latitude: "42.359990",
          longitude: "-71.121535"
        }
      ],
      [
        {
          direction: 295,
          latitude: "42.349250",
          longitude: "-71.107572"
        },
        {
          direction: 250,
          latitude: "42.357093",
          longitude: "-71.128851"
        }
      ],
      [
        {
          direction: 295,
          latitude: "42.351462",
          longitude: "-71.112636"
        },
        {
          direction: 250,
          latitude: "42.355546",
          longitude: "-71.132730"
        }
      ]
    ]
  end
end
