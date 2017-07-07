require "rails_helper"

RSpec.describe Car, type: :model do
  describe "associations" do
    it { should belong_to(:owner) }
    it { should belong_to(:trip) }
    it { should have_many(:locations) }
    it { should have_many(:signups) }
    it { should have_many(:users).through(:signups) }
  end

  describe "validations" do
    it do
      should validate_numericality_of(:max_seats)
        .is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10)
        .only_integer
    end
    it { should validate_presence_of(:max_seats) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:owner) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:trip) }
    it do
      car = create(:car)
      should validate_uniqueness_of(:name).scoped_to(:trip_id)
    end
  end

  describe "set enum" do
    it do
      should define_enum_for(:status)
        .with([:not_started, :in_transit, :arrived])
    end
  end
end
