require "rails_helper"

RSpec.describe Signup, type: :model do
  describe "associations" do
    it { should belong_to(:car) }
    it { should belong_to(:user) }
  end

  describe "validations" do
    it do
      user = create(:user)
      car = create(:car)
      create(:signup, user: user, car: car)
      should validate_uniqueness_of(:trip).scoped_to(:user_id)
    end
    it do
      user = create(:user)
      car = create(:car)
      create(:signup, user: user, car: car)
      should validate_uniqueness_of(:user).scoped_to(:car_id)
    end
  end
end
