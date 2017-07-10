require "rails_helper"

describe "LeaveATrip" do
  describe ".perform" do
    context "with a valid trip and user" do
      let!(:current_user) { create(:user) }

      context "user is signed up for the trip" do
        it "destroys the signup for the trip" do
          signup = create(:signup, user: current_user)

          LeaveATrip.perform(signup.trip, current_user)

          expect { Signup.find(signup.id) }
            .to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "user is signed up for the trip and a car, but does not own the car" do
        it "deletes the signup but not the car" do
          car = create(:car)
          signup = create(:signup, car: car, trip: car.trip, user: current_user)

          LeaveATrip.perform(signup.trip, current_user)

          expect { Signup.find(signup.id) }
            .to raise_error(ActiveRecord::RecordNotFound)
          expect(Car.find(car.id)).to be
        end
      end

      context "user is signed up for the trip and a car, and owns the car" do
        it "deletes the signup and the car" do
          car = create(:car, owner: current_user)
          signup = create(:signup, car: car, trip: car.trip, user: current_user)

          LeaveATrip.perform(signup.trip, current_user)

          expect { Signup.find(signup.id) }
            .to raise_error(ActiveRecord::RecordNotFound)
          expect{ Car.find(car.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "user is signed up for the trip and owns a car in the trip,
        but isn't signed up for the car" do
        it "deletes the signup and the car" do
          car = create(:car, owner: current_user)
          signup = create(:signup, trip: car.trip, user: current_user)

          LeaveATrip.perform(signup.trip, current_user)

          expect { Signup.find(signup.id) }
            .to raise_error(ActiveRecord::RecordNotFound)
          expect{ Car.find(car.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "user is signed up for the trip and owns a car in a different trip" do
        it "deletes the signup but does not delete the other car they own" do
          car = create(:car, owner: current_user)
          signup = create(:signup, user: current_user)

          LeaveATrip.perform(signup.trip, current_user)

          expect { Signup.find(signup.id) }
            .to raise_error(ActiveRecord::RecordNotFound)
          expect(Car.find(car.id)).to be
        end
      end

      context "user is not signed up for the trip" do
        it "raises a MissingSignup error" do
          trip = create(:trip)

          expect{ LeaveATrip.perform(trip, current_user) }
            .to raise_error(MissingSignup, "You are not signed up for this trip")
        end
      end
    end

    context "invalid trip" do
      let!(:current_user) { create(:user) }

      context "nil trip" do
        it "raises ArgumentError and does not delete the signup" do
          signup = create(:signup, user: current_user)

          expect{ LeaveATrip.perform(nil, current_user)}
            .to raise_error(ArgumentError, "expected a trip")
          expect(Signup.find(signup.id)).to be
        end
      end

      context "not a real trip" do
        it "raises ArgumentError and does not delete the signup" do
          signup = create(:signup, user: current_user)

          expect{ LeaveATrip.perform("fake_trip", current_user)}
            .to raise_error(ArgumentError, "expected a trip")
          expect(Signup.find(signup.id)).to be
        end
      end
    end

    context "invalid user" do
      context "nil user" do
        it "raises ArgumentError and does not delete the signup" do
          signup = create(:signup)

          expect{ LeaveATrip.perform(signup.trip, nil)}
            .to raise_error(ArgumentError, "expected a user")
          expect(Signup.find(signup.id)).to be
        end
      end

      context "not a real user" do
        it "raises ArgumentError and does not delete the signup" do
          signup = create(:signup)

          expect{ LeaveATrip.perform(signup.trip, "I'm not real!")}
            .to raise_error(ArgumentError, "expected a user")
          expect(Signup.find(signup.id)).to be
        end
      end

      context "missing user argument" do
        it "raises ArgumentError and does not delete the signup" do
          signup = create(:signup)

          expect{ LeaveATrip.perform(signup.trip)}
            .to raise_error(ArgumentError, "wrong number of arguments (given 1, expected 2)")
          expect(Signup.find(signup.id)).to be
        end
      end
    end
  end
end
