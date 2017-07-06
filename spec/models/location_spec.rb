require "rails_helper"

RSpec.describe Location, type: :model do
  describe "associations" do
    it { should belong_to(:car) }
  end

  describe "validations" do
    it { should have_one(:trip).through(:car) }
    it { should validate_inclusion_of(:direction).in?(-180..180) }
    it { should validate_numericality_of(:direction).only_integer }
    it { should validate_presence_of(:car) }
    it { should validate_presence_of(:direction) }
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }
  end
end
