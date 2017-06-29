require "rails_helper"

describe "CreateACar" do
  context "authorized user" do
    let!(:trip) { create(:trip) }
    let!(:current_user) { create(:user) }

    context "with valid car info" do
      it "returns a car object with user signed up" do
        signup = create(:signup, trip: trip, user: current_user)
        Signup.stub(:find_by).and_return(signup)
        car_params = {
          name: "My Car",
          trip_id: trip.id
        }
        value = CreateACar.perform(car_params, current_user)

        expect(value).to be_a Car
        expect(value.trip).to eq(trip)
        expect(value.users).to include(current_user)
      end
    end

    context "with invalid car info" do
      it "raises RecordInvalid" do
        signup = create(:signup, trip: trip, user: current_user)
        Signup.stub(:find_by).and_return(signup)
        expect do
          CreateACar.perform({ name: nil }, current_user)
        end.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  context "user isn't signed up for the trip" do
    let!(:trip) { create(:trip) }
    let!(:current_user) { create(:user) }

    it "raises RecordInvalid" do
      Signup.stub(:find_by).and_return(nil)
      car_params = {
        name: "My Car",
        trip_id: trip.id
      }

      expect { CreateACar.perform(car_params, current_user) }.to raise_error(MissingSignup,
        "You must be signed up for a trip in order to create a car in that trip")
    end
  end

  context "no user" do
    let!(:trip) { create(:trip) }

    it "raises RecordInvalid" do
      Signup.stub(:find_by).and_return(nil)
      car_params = {
        name: "My Car",
        trip_id: trip.id
      }
      expect { CreateACar.perform(car_params, nil) }.to raise_error(MissingSignup,
        "You must be signed up for a trip in order to create a car in that trip")
    end
  end
end
