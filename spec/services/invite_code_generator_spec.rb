require "rails_helper"

describe InviteCodeGenerator do
  describe ".perform" do
    it "returns an InviteCode with a random invite code" do
      invite_code = InviteCodeGenerator.perform

      expect(invite_code).to be_a InviteCode
      expect(invite_code.code).to_not be nil
      expect(invite_code.code).to be_a String
      expect(invite_code.code.length).to be 6
      expect(invite_code.code).to_not match(/\D/)
    end
  end
end
