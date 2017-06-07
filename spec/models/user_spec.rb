require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:cars).through(:seats) }
    it { should have_many(:seats) }
    it { should have_many(:trips) }
    it { should have_many(:trips).through(:user_trips) }
    it { should have_many(:user_trips) }
  end

  describe "validations" do
    
  end
end
