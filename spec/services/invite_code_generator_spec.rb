require "rails_helper"


describe InviteCodeGenerator do
  describe ".perform" do
    it "returns an InviteCode with a random invite code" do
      response = InviteCodeGenerator.perform

      expect(response).to be_a InviteCode
      expect(response.code).to_not be nil
      expect(response.code).to be_a String
    end
  end
end
