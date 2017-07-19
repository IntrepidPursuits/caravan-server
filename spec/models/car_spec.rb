require "rails_helper"

RSpec.describe Car, type: :model do
  describe "associations" do
    it { should belong_to(:owner) }
    it { should belong_to(:trip) }
    it { should have_many(:checkins) }
    it { should have_many(:locations) }
    it { should have_many(:signups) }
    it { should have_many(:stops).through(:checkins) }
    it { should have_many(:users).through(:signups) }
  end

  describe "validations" do
    it do
      should validate_numericality_of(:max_seats)
        .is_greater_than_or_equal_to(1).is_less_than_or_equal_to(6)
        .only_integer
    end

    it { should validate_presence_of(:max_seats) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:owner) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:trip) }

    it do
      car = create(:car)
      should validate_uniqueness_of(:name).scoped_to(:trip_id)
    end

    it do
      car = create(:car)
      should validate_uniqueness_of(:owner).scoped_to(:trip_id).with_message("User already owns a car for this trip")
    end
  end

  describe "set enum" do
    it do
      should define_enum_for(:status)
        .with([:not_started, :in_transit, :arrived])
    end
  end

  describe "seats_remaining" do
    context "when max_seats is greater than one" do
      it "should equal max_seats less associated users count" do
        car = create(:car, max_seats: 5)
        signup = create(:signup, car: car, user: car.owner, trip: car.trip)
        create(:signup, car: car, trip: car.trip)

        expect(car.seats_remaining).to eq(3)
      end
    end

    context "when no max_seats was specified" do
      it "should equal zero once owner is signed up" do
        car = create(:car)
        signup = create(:signup, car: car, user: car.owner, trip: car.trip)

        expect(car.seats_remaining).to eq(0)
      end
    end
  end

  describe "last_location" do
    it "returns the most recent location for a car" do
      car = create(:car)
      location_1 = create(:location, car: car)
      location_2 = create(:location, car: car)

      expect(car.last_location).to eq(location_2)
    end

    it "does not return locations attached to a different car" do
      car_1 = create(:car)
      car_2 = create(:car)
      location_1 = create(:location, car: car_1)
      location_2 = create(:location, car: car_2)

      expect(car_1.last_location).to eq(location_1)
      expect(car_2.last_location).to eq(location_2)
    end
  end

  describe "near_destination?" do
    it "returns true if the car's last location is within 0.1 miles of the trip's destination" do
      car = create(:car)
      location_1 = create(:location, car: car)
      location_2 = create(:location, car: car, latitude: "42.366137", longitude: "-71.0784625")

      expect(car.near_destination?).to be(true)
    end

    it "returns true if the car's last location is the same as the car's destination" do
      car = create(:car)
      location_1 = create(:location, car: car)
      location_2 = create(:location, car: car, latitude: "42.3662828", longitude: "-71.0799026")

      expect(car.near_destination?).to be(true)
    end

    it "returns false if the car's last location is more than 0.1 miles from the trip's destination" do
      car = create(:car)
      location = create(:location, car: car)

      expect(car.near_destination?).to be(false)
    end
  end
end
