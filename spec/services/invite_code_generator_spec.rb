require "rails_helper"


describe InviteCodeGenerator do
  describe ".new" do
    it "returns an InviteCodeGenerator with a random invite code" do
      response = InviteCodeGenerator.new

      expect(response).to be_a InviteCodeGenerator
      expect(response.invite_code).to_not be nil
      expect(response.invite_code.code).to be_a String
      expect(response.invite_code.code.length).to equal 20
    end
  end
end
