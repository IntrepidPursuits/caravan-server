require "rails_helper"

describe "JoinACar" do
  context "authorized user" do
    let!(:car) { create(:car, max_seats: 2) }
    let!(:owner_signup) { create(:signup, trip: car.trip, car: car, user: car.owner) }
    let!(:current_user) { create(:user) }
    let!(:google_identity) { create(:google_identity, user: current_user) }

    context "user is signed up for the trip and car belongs to the trip" do
      it "updates the signup with the car" do
        signup = create(:signup, trip: car.trip, user: current_user)

        JoinACar.perform(car, current_user)

        signup.reload
        expect(signup.car).to eq(car)
      end
    end

    context "user is signed up for another car on the trip" do
      context "user owns the other car they're signed up for" do
        it "raises UserOwnsCarError" do
          owned_car = create(:car, trip: car.trip, owner: current_user)

          expect(current_user.owned_cars).to include(owned_car)

          signup = create(:signup, trip: car.trip, car: owned_car, user: current_user)

          expect do
            JoinACar.perform(car, current_user)
          end.to raise_error(UserOwnsCarError,
            "Could not join car: user owns another car for this trip")
        end
      end

      context "user does not own the other car they're signed up for" do
        it "updates the signup from one car to the other" do
          other_car = create(:car, trip: car.trip)
          signup = create(:signup, trip: car.trip, user: current_user, car: other_car)

          JoinACar.perform(car, current_user)

          signup.reload
          expect(signup.car).to eq(car)
        end
      end
    end

    context "user is not signed up for the car's trip" do
      it "raises InvalidCarJoin" do
        expect do
          JoinACar.perform(car, current_user)
        end.to raise_error(MissingSignup)
      end
    end

    context "user is signed up for trip but the car is already full" do
      it "raises RecordInvalid" do
        create(:signup, car: car, trip: car.trip)
        create(:signup, trip: car.trip, user: current_user)

        expect do
          JoinACar.perform(car, current_user)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
