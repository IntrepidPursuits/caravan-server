require "rails_helper"

describe LastLocations do
  describe ".perform" do
    it "returns the most recent locations for a list of cars" do
      car1 = create(:car)
      car2 = create(:car)
      create_list(:location, 2, car: car1)
      create_list(:location, 2, car: car2)
      car1_last_location = create(:location, car: car1, latitude: 1.00, longitude: 2.00)
      car2_last_location = create(:location, car: car2, latitude: 3.00, longitude: 4.00)

      last_locations = LastLocations.perform(Car.all)

      expect(last_locations[0].latitude).to eq car1_last_location.latitude
      expect(last_locations[0].longitude).to eq car1_last_location.longitude
      expect(last_locations[1].latitude).to eq car2_last_location.latitude
      expect(last_locations[1].longitude).to eq car2_last_location.longitude
    end
  end
end
