require "rails_helper"

describe CarPolicy do
  let(:user) { create(:user) }
  let(:car) { create(:car) }

  permissions :create_location? do
    it "grants access if the user is signed up for the car & trip" do
      signup = create(:signup, trip: car.trip, car: car, user: user)
      expect(CarPolicy).to permit(user, car)
    end

    it "denies access if the user is not signed up for the car" do
      create(:signup, trip: car.trip, user: user)
      expect(CarPolicy).not_to permit(user, car)
    end

    it "denies access if the user is not signed up for the trip" do
      expect{ create(:signup, car: car, user: user) }
        .to raise_error(ActiveRecord::RecordInvalid)
      expect(CarPolicy).not_to permit(user, car)
    end

    it "denies access when the user is signed up for neither car nor trip" do
      expect(CarPolicy).not_to permit(user, car)
    end
  end

  permissions :show? do
    it "grants access if the user is signed up for the trip" do
      signup = create(:signup, trip: car.trip, user: user)
      expect(CarPolicy).to permit(user, car)
    end

    it "denies access if the user is not signed up for the trip" do
      expect(CarPolicy).not_to permit(user, car)
    end
  end

  permissions :update? do
    it "grants access if the user is signed up for the car" do
      signup = create(:signup, trip: car.trip, car: car, user: user)
      expect(CarPolicy).to permit(user, car)
    end

    it "denies access if the user is not signed up for the car" do
      expect(CarPolicy).not_to permit(user, car)
    end
  end

  permissions :leave_car? do
    it "grants access if the user is signed up for the car and the trip" do
      create(:signup, trip: car.trip, car: car, user: user)
      expect(CarPolicy).to permit(user, car)
    end

    it "denies access if the user is not signed up for the car" do
      create(:signup, trip: car.trip, user: user)
      expect(CarPolicy).not_to permit(user, car)
    end

    it "denies access if the user is not signed up for the trip" do
      car = create(:car)
      expect{ create(:signup, car: car, user: user) }
        .to raise_error(ActiveRecord::RecordInvalid)
      expect(CarPolicy).not_to permit(user, car)
    end

    it "denies access when the user is signed up for neither car nor trip" do
      expect(CarPolicy).not_to permit(user, car)
    end
  end
end
