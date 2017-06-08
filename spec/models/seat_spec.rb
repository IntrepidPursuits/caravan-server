require 'rails_helper'

RSpec.describe Seat, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:car) }
  end

  describe "validations" do
    it { should validate_presence_of(:driver?) }
    it do
      create(:seat)
      should validate_uniqueness_of(:user).scoped_to(:car_id)
    end
  end
end
