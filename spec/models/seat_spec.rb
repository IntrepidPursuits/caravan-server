require "rails_helper"

RSpec.describe Seat, type: :model do
  describe "associations" do
    it { should belong_to(:car) }
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:car_id) }
    it { should validate_presence_of(:user_id) }
    it do
      create(:seat)
      should validate_uniqueness_of(:user).scoped_to(:car_id)
    end
  end
end
