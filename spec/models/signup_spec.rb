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
    it do
      user = create(:user)
      car = create(:car)
      create(:signup, user: user, car: car, trip: car.trip)
      should validate_uniqueness_of(:trip).scoped_to(:user_id)
    end
    it do
      car = create(:car)
      user = create(:user)
      create(:signup, user: user, car: car, trip: car.trip)
      should validate_uniqueness_of(:car).scoped_to([:trip_id, :user_id]).allow_nil
    end
    it do
      car = create(:car)
      user = create(:user)
      create(:signup, user: user, car: car, trip: car.trip)
      should validate_with(CarTripMatchValidator)
    end
    it do
      car = create(:car)
      user = create(:user)
      create(:signup, user: user, car: car, trip: car.trip)
      should validate_with(CarSeatsLimitValidator)
    end
  end
end
