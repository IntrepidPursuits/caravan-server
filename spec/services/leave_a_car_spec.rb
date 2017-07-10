require "rails_helper"

describe "LeaveACar" do
  describe ".perform" do
    context "authorized user" do
      let!(:current_user) { create(:user) }

      context "with valid car and signup" do
        context "user is the car owner" do
          it "destroys the car" do
            car = create(:car, owner: current_user)
            signup = create(:signup, trip: car.trip, car: car, user: current_user)

            LeaveACar.perform(car, current_user)

            expect{ Car.find(car.id) }.to raise_error(ActiveRecord::RecordNotFound)
          end

          it "updates all signups for the car to have a car_id of nil" do
            car = create(:car, owner: current_user, max_seats: 2)
            signup = create(:signup, trip: car.trip, car: car, user: current_user)
            signup2 = create(:signup, trip: car.trip, car: car)

            LeaveACar.perform(car, current_user)

            expect(Signup.where(car_id: car.id)).to eq([])
            signup.reload
            expect(signup.car).to eq(nil)
            signup2.reload
            expect(signup2.car).to eq(nil)
          end
        end

        context "user is not the car owner" do
          it "updates the user's signup to have a car_id of nil" do
            car = create(:car)
            signup = create(:signup, trip: car.trip, car: car, user: current_user)

            LeaveACar.perform(car, current_user)

            signup.reload
            expect(signup.car).to eq(nil)
          end

          it "leaves the car intact" do
            car = create(:car, max_seats: 5)
            owner_signup = create(:signup, car: car, trip: car.trip, user: car.owner)
            signup = create(:signup, trip: car.trip, car: car, user: current_user)

            LeaveACar.perform(car, current_user)

            car.reload
            expect(car).to be
            expect(car.users).to_not include(current_user)
            owner_signup.reload
            expect(owner_signup.car).to eq(car)
          end
        end
      end

      context "user tries to sign up for the car but not the trip" do
        it "raises InvalidCarLeave & leaves the car & any signups intact" do
          car = create(:car)
          expect { signup = create(:signup, car: car, user: current_user) }
            .to raise_error(ActiveRecord::RecordInvalid,
            "Validation failed: Car must belong to the Signup's trip")
          users = car.users

          expect{ LeaveACar.perform(car, current_user) }
            .to raise_invalid_car_leave

          car.reload
          expect(car).to be
          expect(car.users).to eq(users)
        end
      end

      context "user is signed up for the trip but not the car" do
        it "raises InvalidCarLeave & leaves the car & any signups intact" do
          car = create(:car)
          signup = create(:signup, trip: car.trip, user: current_user)
          users = car.users

          expect{ LeaveACar.perform(car, current_user) }
            .to raise_invalid_car_leave

          car.reload
          expect(car).to be
          expect(car.users).to eq(users)
        end
      end

      context "user is not signed up for the car or the trip" do
        it "raises InvalidCarLeave & leaves the car & any signups intact" do
          car = create(:car)
          users = car.users

          expect{ LeaveACar.perform(car, current_user) }
            .to raise_invalid_car_leave

          car.reload
          expect(car).to be
          expect(car.users).to eq(users)
        end
      end

      context "without a valid car" do
        context "nil car" do
          it "raises InvalidCarLeave" do
            expect{ LeaveACar.perform(nil, current_user) }
              .to raise_invalid_car_leave
          end
        end

        context "invalid car" do
          it "raises InvalidCarLeave" do
            expect{ LeaveACar.perform("bubbagumpshrimp", current_user) }
              .to raise_invalid_car_leave
          end
        end

        context "no car argument" do
          it "raises ArgumentError" do
            expect{ LeaveACar.perform(current_user) }
              .to raise_error(ArgumentError,
                "wrong number of arguments (given 1, expected 2)")
          end
        end
      end
    end

    context "without a valid user" do
      context "nil user" do
        it "raises InvalidCarLeave & leaves the car & signup intact" do
          car = create(:car)
          signup = create(:signup, trip: car.trip, car: car, user: car.owner)

          expect{ LeaveACar.perform(car, nil) }
            .to raise_error(ArgumentError, "expected a user")

          car.reload
          expect(car).to be

          signup.reload
          expect(signup).to be
          expect(signup.car).to eq(car)
        end
      end

      context "invalid user" do
        it "raises InvalidCarLeave & leaves the car & signup intact" do
          car = create(:car)
          signup = create(:signup, trip: car.trip, car: car, user: car.owner)

          expect{ LeaveACar.perform(car, "pookie") }
            .to raise_error(ArgumentError, "expected a user")

          car.reload
          expect(car).to be

          signup.reload
          expect(signup).to be
          expect(signup.car).to eq(car)
        end
      end

      context "no user argument" do
        it "raises ArgumentError" do
          car = create(:car)
          signup = create(:signup, trip: car.trip, car: car, user: car.owner)

          expect{ LeaveACar.perform(car) }
            .to raise_error(ArgumentError,
            "wrong number of arguments (given 1, expected 2)")
        end
      end
    end
  end

  def raise_invalid_car_leave
    raise_error(InvalidCarLeave,
      "Unable to leave car; it doesn't exist or user is not signed up properly.")
  end
end
