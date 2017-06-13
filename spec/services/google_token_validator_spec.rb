require "rails_helper"

RSpec.describe "GoogleTokenValidator" do
  context "with a valid token" do
    before(:each) do
      stub_google_token_request
    end

    describe ".token_hash" do
      it "sets the token_hash" do
        token_validator = GoogleTokenValidator.new(google_token)
        expect(token_validator.token_hash).to be
      end
    end
  end

  def google_token
    { google_token: SecureRandom.hex(20) }.to_json
  end
end
