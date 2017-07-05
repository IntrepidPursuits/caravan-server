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
            car = create(:car, owner: current_user)
            signup = create(:signup, trip: car.trip, car: car, user: current_user)

            LeaveACar.perform(car, current_user)

            expect(Signup.where(car_id: car.id)).to eq []
            updated_signup = Signup.find(signup.id)
            expect(updated_signup.car).to eq nil
          end
        end

        context "user is not the car owner" do
          it "updates the user's signup to have a car_id of nil" do
            car = create(:car)
            signup = create(:signup, trip: car.trip, car: car, user: current_user)

            LeaveACar.perform(car, current_user)

            expect(Signup.find(signup.id).car).to eq nil
          end

          it "leaves the car intact" do
            car = create(:car)
            signup = create(:signup, trip: car.trip, car: car, user: current_user)

            LeaveACar.perform(car, current_user)

            expect(Car.find(car.id)).to eq car
          end
        end
      end

      context "invalid car" do
        context "nil car" do
          it "raises NoMethodError" do
            expect{
              LeaveACar.perform(nil, current_user)
            }.to raise_error(NoMethodError, "undefined method `trip' for nil:NilClass")
          end
        end

        context "no car argument" do
          it "raises ArgumentError" do
            expect{ LeaveACar.perform(current_user) }
              .to raise_error(ArgumentError, "wrong number of arguments (given 1, expected 2)")
          end
        end
      end

      context "user is not signed up for the car" do
        it "raises NoMethodError" do
          car = create(:car)

          expect{
            LeaveACar.perform(car, current_user)
          }.to raise_error(NoMethodError, "undefined method `update_attributes!' for nil:NilClass")
        end
      end
    end

    context "no user" do
      context "nil user" do
        it "raises NoMethodError & leaves the car & signup intact" do
          car = create(:car)
          signup = create(:signup, trip: car.trip, car: car, user: car.owner)

          expect{ LeaveACar.perform(car, nil) }
            .to raise_error(NoMethodError, "undefined method `update_attributes!' for nil:NilClass")

          updated_car = Car.find(car.id)
          expect(updated_car).to eq car

          updated_signup = Signup.find(signup.id)
          expect(updated_signup).to eq signup
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
end
