require "rails_helper"

RSpec.describe Car, type: :model do
  describe "associations" do
    it { should belong_to(:trip) }
    it { should have_many(:locations) }
    it { should have_many(:signups) }
    it { should have_many(:users).through(:signups) }
  end

  describe "validations" do
    it { should validate_numericality_of(:max_seats).is_equal_to(1) }
    it { should validate_presence_of(:max_seats) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:trip) }
  end

  describe "set enum" do
    it do
      should define_enum_for(:status)
        .with([:not_started, :in_transit, :arrived])
    end
  end
end
