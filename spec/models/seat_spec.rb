require 'rails_helper'

RSpec.describe Seat, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:car) }
  end

  describe "validations" do
    it { should validate_presence_of(:driver?) }
    it { should validate_inclusion_of(:driver?).in_array([:true, :false]) }
  end
end
