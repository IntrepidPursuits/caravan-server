require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_one(:google_identity) }

    it { should have_many(:signups) }
    it { should have_many(:cars).through(:signups) }
    it { should have_many(:created_trips) }
    it { should have_many(:owned_cars) }
    it { should have_many(:trips).through(:signups) }
  end
end
