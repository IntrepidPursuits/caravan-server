require "rails_helper"


describe InviteCodeGenerator do
  describe ".new" do
    context "with no length" do
      it "returns an InviteCodeGenerator with a random invite code" do
        response = InviteCodeGenerator.new

        expect(response).to be_a InviteCodeGenerator
        expect(response.invite_code).to_not be nil
        expect(response.invite_code).to be_a String
        expect(response.invite_code.length).to equal 10
      end
    end
    context "with length specified" do
      it "returns an InviteCodeGenerator with a random invite code" do
        response = InviteCodeGenerator.new(20)

        expect(response).to be_a InviteCodeGenerator
        expect(response.invite_code).to_not be nil
        expect(response.invite_code).to be_a String
        expect(response.invite_code.length).to equal 20
      end
    end
  end
end
