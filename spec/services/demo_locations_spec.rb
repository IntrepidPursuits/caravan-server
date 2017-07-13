require "rails_helper"

RSpec.describe "DemoLocations" do
  describe ".location_data" do
    it "is an array of arrays of valid floats" do
      demo = DemoLocations.new

      expect(demo.location_data).to be_a(Array)
      demo.location_data.each do |location|
        expect(location).to be_a(Array)
        expect(location.length).to eq(4)

        location.each do |lat_or_long|
          expect(valid_float?(lat_or_long)).to be(true)
        end
      end
    end
  end

  describe ".build_stops_data" do
    it "returns an array of stops with two cars in each stop and correct data" do
      demo = DemoLocations.new

      expect(demo.build_stops_data).to be_a(Array)
      demo.build_stops_data.each do |stop|
        expect(stop).to be_a(Array)
        expect(stop.count).to be(2)

        stop.each do |car|
          expect(car[:owner_token]).to be
          expect(car[:car_id]).to be
          expect(car[:location][:latitude]).to be
          expect(car[:location][:longitude]).to be
        end
      end
    end
  end

  describe ".reset_locations" do
    it "adds the original locations back to the cars" do
      stub_reset_locations
      allow_any_instance_of(DemoLocations).to receive(:sleep)
      demo = DemoLocations.new
      response = demo.reset_locations

      last_locations = JSON.parse(response)["trip_locations"]["last_locations"]
      expect(last_locations[0]["car_id"]).to eq(demo.car1_id)
      expect(last_locations[0]["latitude"]).to eq("42.367124")
      expect(last_locations[0]["longitude"]).to eq("-71.081569")
      expect(last_locations[1]["car_id"]).to eq(demo.car2_id)
      expect(last_locations[1]["latitude"]).to eq("42.366565")
      expect(last_locations[1]["longitude"]).to eq("-71.077874")
    end
  end

  describe ".perform" do
    it "adds the correct list of locations to the cars, and ends up a the right place" do
      stub_post_locations
      allow_any_instance_of(DemoLocations).to receive(:sleep)
      demo = DemoLocations.new
      response = demo.perform

      last_locations = JSON.parse(response)["trip_locations"]["last_locations"]
      expect(last_locations[0]["car_id"]).to eq(demo.car1_id)
      expect(last_locations[0]["latitude"]).to eq(demo.location_data.last[0])
      expect(last_locations[0]["longitude"]).to eq(demo.location_data.last[1])
      expect(last_locations[1]["car_id"]).to eq(demo.car2_id)
      expect(last_locations[1]["latitude"]).to eq(demo.location_data.last[2])
      expect(last_locations[1]["longitude"]).to eq(demo.location_data.last[3])
    end
  end
end

def valid_float?(str)
  true if Float(str) rescue false
end
