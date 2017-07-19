require "rails_helper"

RSpec.describe Trip, type: :model do
  describe "associations" do
    it { should belong_to(:creator) }
    it { should belong_to(:invite_code) }
    it { should have_many(:cars) }
    it { should have_many(:locations).through(:cars) }
    it { should have_many(:signups) }
    it { should have_many(:users).through(:signups) }
  end

  describe "validations" do
    it { should validate_numericality_of(:destination_latitude)
      .is_greater_than_or_equal_to(-90).is_less_than_or_equal_to(90) }
    it { should validate_numericality_of(:destination_longitude)
      .is_greater_than_or_equal_to(-180).is_less_than_or_equal_to(180) }
    it { should validate_presence_of(:creator) }
    it { should validate_presence_of(:departing_on) }
    it { should validate_presence_of(:destination_address) }
    it { should validate_presence_of(:destination_latitude) }
    it { should validate_presence_of(:destination_longitude) }
    it { should validate_presence_of(:invite_code_id) }
    it { should validate_presence_of(:name) }
  end

  describe "car_owners" do
    context "there are no cars in the trip" do
      it "returns an empty array" do
        trip = create(:trip)

        expect(trip.car_owners).to eq([])
      end
    end

    context "there are cars in the trip" do
      it "returns an array of the owners of the trip's cars" do
        trip = create(:trip)
        car1, car2 = create_list(:car, 2, trip: trip)

        expect(trip.car_owners).to eq([car1.owner, car2.owner])
      end
    end
  end

  describe "last_locations" do
    it "returns the most recent locations for each car in the trip" do
      trip = create(:trip)
      car1 = create(:car, trip: trip)
      car2 = create(:car, trip: trip)
      create_list(:location, 2, car: car1)
      create_list(:location, 2, car: car2)
      car1_last_location = create(:location, car: car1, latitude: 1.00, longitude: 2.00)
      car2_last_location = create(:location, car: car2, latitude: 3.00, longitude: 4.00)

      expect(trip.last_locations[0].latitude).to eq car1_last_location.latitude
      expect(trip.last_locations[0].longitude).to eq car1_last_location.longitude
      expect(trip.last_locations[1].latitude).to eq car2_last_location.latitude
      expect(trip.last_locations[1].longitude).to eq car2_last_location.longitude
    end
  end

  describe "upcoming?" do
    context "departure date in the future" do
      it "returns true" do
        trip = create(:trip, departing_on: Date.today + 1.day)

        expect(trip.upcoming?).to eq(true)
      end
    end

    context "departure date is today" do
      it "returns true" do
        trip = create(:trip, departing_on: Date.today)

        expect(trip.upcoming?).to eq(true)
      end
    end

    context "departure date in the past" do
      it "returns false" do
        trip = create(:trip, departing_on: Date.today - 1.day)

        expect(trip.upcoming?).to eq(false)
      end
    end
  end
end
