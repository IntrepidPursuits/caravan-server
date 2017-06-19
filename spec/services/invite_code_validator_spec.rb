require "rails_helper"

describe InviteCodeValidator do
  describe ".perform" do
    context "valid invite code" do
      it "returns true" do
        trip = create(:trip)
        valid_invite_code = trip.invite_code.code
        success = InviteCodeValidator.perform(trip, valid_invite_code)

        expect(success).to be true
      end
    end

    context "invalid invite code" do
      it "raises an InvalidInviteCodeError" do
        trip = create(:trip)
        invalid_invite_code = "abcdef"

        expect do
          InviteCodeValidator.perform(trip, invalid_invite_code)
        end.to raise_error(InvalidInviteCodeError)
      end
    end
  end
end
