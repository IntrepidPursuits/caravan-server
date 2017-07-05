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

            LeaveACar.perform(car, signup, current_user)

            expect{ Car.find(car.id) }.to raise_error(ActiveRecord::RecordNotFound)
          end

          it "updates all signups for the car to have a car_id of nil" do
            car = create(:car, owner: current_user)
            signup = create(:signup, trip: car.trip, car: car, user: current_user)

            LeaveACar.perform(car, signup, current_user)

            expect(Signup.where(car_id: car.id)).to eq []
            updated_signup = Signup.find(signup.id)
            expect(updated_signup.car).to eq nil
          end
        end

        context "user is not the car owner" do
          it "updates the user's signup to have a car_id of nil" do
            car = create(:car)
            signup = create(:signup, trip: car.trip, car: car, user: current_user)

            LeaveACar.perform(car, signup, current_user)

            expect(Signup.find(signup.id).car).to eq nil
          end

          it "leaves the car intact" do
            car = create(:car)
            signup = create(:signup, trip: car.trip, car: car, user: current_user)

            LeaveACar.perform(car, signup, current_user)

            expect(Car.find(car.id)).to eq car
          end
        end
      end

      context "with invalid car" do
        it "raises NoMethodError" do
          signup = create(:signup, user: current_user)

          expect{
            LeaveACar.perform(nil, signup, current_user)
          }.to raise_error(NoMethodError, "undefined method `owner' for nil:NilClass")
        end
      end

      context "with invalid signup" do
        it "raises NoMethodError" do
          car = create(:car)

          expect{
            LeaveACar.perform(car, nil, current_user)
          }.to raise_error(NoMethodError, "undefined method `update_attributes!' for nil:NilClass")
        end
      end
    end

    context "no user" do
      it "does nothing" do
        car = create(:car)
        signup = create(:signup, trip: car.trip, car: car, user: car.owner)

        LeaveACar.perform(car, signup, nil)

        updated_car = Car.find(car.id)
        expect(updated_car).to eq car

        updated_signup = Signup.find(signup.id)
        expect(updated_signup).to eq signup
      end
    end
  end
end
