require "rails_helper"

RSpec.describe "LocationSimulator" do
  describe ".build_stops_data" do
    it "returns an array of stops with two cars in each stop and correct data" do
      simulator = LocationSimulator.new

      expect(simulator.build_stops_data).to be_a(Array)
      simulator.build_stops_data.each do |stop|
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
      allow_any_instance_of(LocationSimulator).to receive(:sleep)
      allow_any_instance_of(LocationSimulator).to receive(:print_resetting)
      allow_any_instance_of(LocationSimulator).to receive(:print_success)
      simulator = LocationSimulator.new
      response = simulator.reset_locations

      last_locations = JSON.parse(response)["trip_locations"]["last_locations"]
      expect(last_locations[0]["car_id"]).to eq(simulator.car1_id)
      expect(last_locations[0]["direction"]).to eq(200)
      expect(last_locations[0]["latitude"]).to eq("42.367124")
      expect(last_locations[0]["longitude"]).to eq("-71.081569")
      expect(last_locations[1]["car_id"]).to eq(simulator.car2_id)
      expect(last_locations[1]["direction"]).to eq(190)
      expect(last_locations[1]["latitude"]).to eq("42.366565")
      expect(last_locations[1]["longitude"]).to eq("-71.077874")
    end
  end

  describe ".perform" do
    it "adds the correct list of locations to the cars, and ends up at the right place" do
      stub_post_locations
      allow_any_instance_of(LocationSimulator).to receive(:sleep)
      allow_any_instance_of(LocationSimulator).to receive(:print_resetting)
      allow_any_instance_of(LocationSimulator).to receive(:print_success)
      simulator = LocationSimulator.new
      response = simulator.perform

      last_locations = JSON.parse(response)["trip_locations"]["last_locations"]
      expect(last_locations[0]["car_id"]).to eq(simulator.car1_id)
      expect(last_locations[0]["direction"]).to eq(SIMULATOR_LOCATION_DATA.last[0][:direction])
      expect(last_locations[0]["latitude"]).to eq(SIMULATOR_LOCATION_DATA.last[0][:latitude])
      expect(last_locations[0]["longitude"]).to eq(SIMULATOR_LOCATION_DATA.last[0][:longitude])
      expect(last_locations[1]["car_id"]).to eq(simulator.car2_id)
      expect(last_locations[1]["direction"]).to eq(SIMULATOR_LOCATION_DATA.last[1][:direction])
      expect(last_locations[1]["latitude"]).to eq(SIMULATOR_LOCATION_DATA.last[1][:latitude])
      expect(last_locations[1]["longitude"]).to eq(SIMULATOR_LOCATION_DATA.last[1][:longitude])
    end
  end
end
