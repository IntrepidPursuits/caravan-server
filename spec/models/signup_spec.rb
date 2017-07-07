require "rails_helper"

RSpec.describe Signup, type: :model do
  describe "associations" do
    it { should belong_to(:car) }
    it { should belong_to(:trip) }
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:trip) }
    it { should validate_presence_of(:user) }

    let!(:car)  { create(:car) }

    it do
      create(:signup, car: car, trip: car.trip)
      should validate_uniqueness_of(:trip).scoped_to(:user_id)
    end

    it do
      create(:signup, car: car, trip: car.trip)
      should validate_uniqueness_of(:car).scoped_to(:user_id).allow_nil
    end

    context "when the car has at least one empty seat" do
      context "when the car belongs to the trip" do
        it "allows users to sign up" do
          signup = build(:signup, car: car, trip: car.trip)

          expect(signup.valid?).to eq(true)
        end
      end

      context "when the car does not belong to the trip" do
        it "does not save" do
          signup = build(:signup, car: car)

          expect(signup.valid?).to eq(false)
          expect{ signup.save! }.to raise_error(ActiveRecord::RecordInvalid,
            "Validation failed: Car must belong to the Signup's trip")
        end
      end
    end

    context "when the car is full" do
      context "when the car belongs to the trip" do
        it "does not allow users to sign up" do
          create(:signup, car: car, trip: car.trip)
          signup = build(:signup, car: car, trip: car.trip)

          expect(signup.valid?).to eq(false)
          expect{ signup.save! }.to raise_error(ActiveRecord::RecordInvalid,
            "Validation failed: Car is full! Sorry!")
        end
      end

      context "when the car does not belong to the trip" do
        it "does not allow users to sign up" do
          create(:signup, car: car, trip: car.trip)
          signup = build(:signup, car: car)

          expect(signup.valid?).to eq(false)
          expect{ signup.save! }.to raise_error(ActiveRecord::RecordInvalid,
            "Validation failed: Car must belong to the Signup's trip, Car is full! Sorry!")
        end
      end
    end
  end
end
