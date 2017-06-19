require "rails_helper"

RSpec.describe "GoogleTokenValidator" do
  context "with a valid token" do
    before(:each) do
      stub_google_token_request
    end

    describe ".perform" do
      it "returns true" do
        expect(GoogleTokenValidator.perform(google_token)).to be(true)
      end
    end

    describe ".token_hash" do
      it "sets the token_hash" do
        token_validator = GoogleTokenValidator.new(google_token)
        expect(token_validator.token_hash).to be
        expect(token_validator.token_hash[:google_uid]).to eq("user_id")
        expect(token_validator.token_hash[:email]).to be nil
      end
    end
  end

  context "with an invalid token" do
    describe ".perform" do
      it "returns false" do
        stub_bad_token_request
        expect do
          GoogleTokenValidator.to receive(:perform).and_return(false)
        end
      end
    end
  end

  def google_token
    { google_token: SecureRandom.hex(20) }.to_json
  end
end
