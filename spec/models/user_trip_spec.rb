require 'rails_helper'

RSpec.describe UserTrip, type: :model do
  describe "associations" do
    it { should belong_to(:trip) }
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_uniqueness_of(:user_id).scoped_to(:trip_id) }
  end
end
