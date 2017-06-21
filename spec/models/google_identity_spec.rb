require 'rails_helper'

RSpec.describe GoogleIdentity, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:uid) }
    it { should validate_presence_of(:user) }
    it do
      person = create(:user)
      create(:google_identity, user: person)
      should validate_uniqueness_of(:email)
    end
    it do
      person = create(:user)
      create(:google_identity, user: person)
      should validate_uniqueness_of(:uid)
    end
    it do
      person = create(:user)
      create(:google_identity, user: person)
      should validate_uniqueness_of(:user)
    end
  end
end
