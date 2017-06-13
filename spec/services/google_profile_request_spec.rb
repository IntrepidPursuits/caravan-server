require "rails_helper"

RSpec.describe "GoogleProfileRequest" do
  context "for an invalid google uid" do
    it "raise an error" do
      expect do
        stub_bad_id_request
      end.to raise_error GoogleProfileRequest::InvalidGoogleUser
    end
  end
end
