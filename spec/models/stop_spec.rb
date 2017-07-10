require "rails_helper"

describe Stop, type: :model do
  describe "associations" do
    it { should belong_to(:trip) }
    it { should have_many(:locations) }
    it { should have_many(:cars).through(:locations) }
  end

  describe "validations" do
    it { should validate_presence_of(:trip) }
  end
end
