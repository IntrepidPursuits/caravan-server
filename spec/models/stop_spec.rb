require "rails_helper"

describe Stop, type: :model do
  describe "associations" do
    it { should belong_to(:trip) }
    it { should have_many(:checkins) }
    it { should have_many(:cars).through(:checkins) }
  end

  describe "validations" do
    it { should validate_numericality_of(:latitude)
      .is_greater_than_or_equal_to(-90).is_less_than_or_equal_to(90) }
    it { should validate_numericality_of(:longitude)
      .is_greater_than_or_equal_to(-180).is_less_than_or_equal_to(180) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }
    it { should validate_presence_of(:trip) }

    it do
      create(:stop)
      should validate_uniqueness_of(:address).scoped_to(:trip_id)
    end

    it do
      create(:stop)
      should validate_uniqueness_of(:name).scoped_to(:trip_id)
    end
  end
end
