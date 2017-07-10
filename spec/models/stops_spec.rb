require "rails_helper"

describe Stops, type: :model do
  describe "associations" do
    it { should belong_to(:trip) }
    it { should have_many(:locations) }
    it { should have_many(:cars).through(:locations) }
  end

  describe "validations" do
    it { should validate_presence_of(:trip) }
    it { should validate_uniqueness_of(:car).scoped_to(:trip_id) }
  end
end
