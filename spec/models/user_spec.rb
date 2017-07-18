require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_one(:google_identity) }
    it { should have_one(:twitter_identity) }

    it { should have_many(:signups) }
    it { should have_many(:cars).through(:signups) }
    it { should have_many(:created_trips) }
    it { should have_many(:owned_cars) }
    it { should have_many(:trips).through(:signups) }
  end

  describe "upcoming_trips" do
    it "returns only the trips in the future, in order of departure date" do
      user = create(:user)
      trip_1 = create(:trip, creator: user, departing_on: DateTime.now - 1.day)
      trip_2 = create(:trip, creator: user, departing_on: DateTime.now + 1.day)
      trip_3 = create(:trip, creator: user, departing_on: DateTime.now)

      Trip.all.each do |trip|
        create(:signup, user: user, trip: trip)
      end

      expect(user.trips.length).to eq(3)
      expect(user.upcoming_trips.length).to eq(2)
      expect(user.upcoming_trips[0]).to eq(trip_3)
      expect(user.upcoming_trips[1]).to eq(trip_2)
    end
  end
end
