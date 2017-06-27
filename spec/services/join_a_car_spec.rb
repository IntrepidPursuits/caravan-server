require "rails_helper"

describe "JoinACar" do
  context "authorized user" do
    let!(:car) { create(:car) }
    let!(:current_user) { create(:user) }

    context "user is signed up for the trip and car belongs to the trip" do
      it "returns a car object" do
        signup = create(:signup, trip: car.trip, user: current_user)
        value = JoinACar.perform(car, signup, current_user)

        expect(value).to be_a Car
        expect(value).to eq(car)
      end
    end

    context "invalid car" do
      it "raises RecordInvalid" do
        signup = create(:signup, user: current_user)
        expect do
          JoinACar.perform("not a car", signup, current_user)
        end.to raise_error ActiveRecord::RecordInvalid
      end
    end

    context "valid car, but car belongs to a different trip" do
      it "raises RecordInvalid" do
        signup = create(:signup, user: current_user)
        expect do
          JoinACar.perform(car, signup, current_user)
        end.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end
end
