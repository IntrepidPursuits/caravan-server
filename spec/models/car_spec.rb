require "rails_helper"

RSpec.describe Car, type: :model do
  describe "associations" do
    it { should belong_to(:trip) }
    it { should have_many(:locations) }
    it { should have_many(:seats) }
    it { should have_many(:users).through(:seats) }
  end

  describe "validations" do
    it { should validate_inclusion_of(:num_seats).in_range(1..25) }
    it { should validate_presence_of(:num_seats) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:trip) }
  end

  describe "set enum" do
    it { should define_enum_for(:status)
      .with([:not_started, :in_transit, :arrived]) }
  end
end
