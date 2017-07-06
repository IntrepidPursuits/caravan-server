require "rails_helper"

RSpec.describe TwitterIdentity, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:twitter_id) }
    it { should validate_presence_of(:user) }
    it do
      create(:twitter_identity)
      should validate_uniqueness_of(:twitter_id)
      should validate_uniqueness_of(:user)
    end
  end
end
