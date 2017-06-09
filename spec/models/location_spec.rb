require "rails_helper"

RSpec.describe Location, type: :model do
  describe "associations" do
    it { should belong_to(:car) }
  end

  describe "validations" do
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }
  end
end
