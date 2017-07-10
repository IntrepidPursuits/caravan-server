require "rails_helper"

RSpec.describe Location, type: :model do
  describe "associations" do
    it { should belong_to(:car) }
    it { should belong_to(:stop) }
  end

  describe "validations" do
    it { should have_one(:trip).through(:car) }
    it { should validate_numericality_of(:direction)
      .is_greater_than_or_equal_to(-180).is_less_than_or_equal_to(180)
      .only_integer }
    it { should validate_presence_of(:car) }
    it { should validate_presence_of(:direction) }
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }

    it do
      stop = create(:stop)
      create(:location, stop: stop)
      should validate_uniqueness_of(:stop).scoped_to(:car_id).allow_nil
    end
  end
end
