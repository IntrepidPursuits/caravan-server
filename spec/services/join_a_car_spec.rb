require "rails_helper"

describe "JoinACar" do
  context "authorized user" do
    it "returns a car object" do
      car = create(:car)
      trip = car.trip
      signup = create(:signup, trip: trip)
      current_user = signup.user
      value = JoinACar.perform(car.id, trip.id, current_user)
      expect(value).to eq(car)
    end
  end

  context "user isn't signed up for the trip" do
    it "raises UserNotAuthorizedError" do
      car = create(:car)
      car_id = car.id
      trip_id = car.trip_id
      current_user = create(:user)
      expect { JoinACar.perform(car_id, trip_id, current_user) }.to raise_error UserNotAuthorizedError
    end
  end

  context "invalid car" do
    it "raises RecordNotFound" do
      signup = create(:signup)
      expect { JoinACar.perform("not a car", signup.trip_id, signup.user) }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  context "valid car, but car belongs to a different trip" do
    it "raises RecordInvalid" do
      car = create(:car)
      signup = create(:signup)
      expect { JoinACar.perform(car.id, signup.trip_id, signup.user) }.to raise_error ActiveRecord::RecordInvalid
    end
  end
end
