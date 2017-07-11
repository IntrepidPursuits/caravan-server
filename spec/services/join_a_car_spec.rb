require "rails_helper"

describe "JoinACar" do
  context "authorized user" do
    let!(:car) { create(:car) }
    let!(:current_user) { create(:user) }

    context "user is signed up for the trip and car belongs to the trip" do
      it "returns a car object" do
        signup = create(:signup, trip: car.trip, user: current_user)
        value = JoinACar.perform(car, signup, current_user)

        expect(value).to be_a(Car)
        expect(value).to eq(car)
      end
    end

    context "user is signed up for another car on the trip" do
      context "user owns the other car they're signed up for" do
        it "raises UserOwnsCarError" do
          owned_car = create(:car, trip: car.trip, owner: current_user)
          expect(current_user.owned_cars).to include(owned_car)

          signup = create(:signup, trip: car.trip, car: owned_car, user: current_user)
          expect do
            JoinACar.perform(car, signup, current_user)
          end.to raise_error(UserOwnsCarError,
            "Could not join car: user owns another car for this trip")
        end
      end

      context "user does not own the other car" do
        it "returns a car object" do
          other_car = create(:car, trip: car.trip)
          signup = create(:signup, trip: car.trip, user: current_user, car: other_car)
          value = JoinACar.perform(car, signup, current_user)

          expect(value).to be_a(Car)
          expect(value).to eq(car)
        end
      end
    end

    context "invalid car" do
      it "raises InvalidCarJoin" do
        signup = create(:signup, user: current_user)
        expect do
          JoinACar.perform("not a car", signup, current_user)
        end.to raise_error(InvalidCarJoin)
      end
    end

    context "valid car, but car belongs to a different trip" do
      it "raises InvalidCarJoin" do
        signup = create(:signup, user: current_user)
        expect do
          JoinACar.perform(car, signup, current_user)
        end.to raise_error(InvalidCarJoin)
      end
    end

    context "valid car, but it's full" do
      it "raises RecordInvalid" do
        create(:signup, car: car, trip: car.trip)
        signup = create(:signup, trip: car.trip, user: current_user)
        expect do
          JoinACar.perform(car, signup, current_user)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
