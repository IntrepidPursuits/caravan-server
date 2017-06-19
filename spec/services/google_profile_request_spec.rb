require "rails_helper"

RSpec.describe "GoogleProfileRequest" do
  context "for an invalid google uid" do
    it "raise an error" do
      stub_bad_token_request
      expect do
        GoogleProfileRequest.perform("a")
      end.to raise_error GoogleProfileRequest::InvalidGoogleUser
    end

    context "with valid token and client id" do
      before(:each) do
        stub_google_profile_request
      end

      describe ".perform" do
        it "returns valid JSON for the current user" do
          expect do
            GoogleProfileRequest.to receive(:perform).and_respond("adsfjksbf")
            # valid json here
            # why is this passing????
          end
        end
      end
    end
  end
end
