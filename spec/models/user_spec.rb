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

  describe "email" do
    context "user has a google identity" do
      it "returns the email from the associated google_identity" do
        google_identity = create(:google_identity)
        user = google_identity.user

        expect(user.email).to eq(google_identity.email)
      end
    end

    context "user does not have a google_identity" do
      it "returns nil" do
        user = create(:user)

        expect(user.email).not_to be
      end
    end
  end

  describe "image" do
    context "user has a google identity" do
      it "returns the image from the associated google_identity" do
        google_identity = create(:google_identity)
        user = google_identity.user

        expect(user.image).to eq(google_identity.image)
      end
    end

    context "user does not have a google_identity" do
      it "returns nil" do
        user = create(:user)

        expect(user.image).not_to be
      end
    end
  end

  describe "upcoming_trips" do
    it "returns only the trips in the future, in order of departure date" do
      user = create(:user)
      trip_1 = create(:trip, creator: user, departing_on: Date.today - 1.day)
      trip_2 = create(:trip, creator: user, departing_on: Date.today + 1.day)
      trip_3 = create(:trip, creator: user, departing_on: Date.today)

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
