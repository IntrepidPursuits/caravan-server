require "rails_helper"

RSpec.describe "GoogleTokenValidator" do
  context "with a valid token" do
    before(:each) do
      stub_google_token_request
    end

    describe ".perform" do
      it "returns true" do
        response = GoogleTokenValidator.perform(google_token)
        expect(response).to be(true)
      end
    end

    describe ".token_hash" do
      it "sets the token_hash" do
        token_validator = GoogleTokenValidator.new(google_token)
        expect(token_validator.token_hash).to be
        expect(token_validator.token_hash[:google_uid]).to eq("118041628242866040308")
        expect(token_validator.token_hash[:email]).to eq("rkonikoff@intrepid.io")
        expect(token_validator.token_hash[:name]).to eq("Riki Konikoff")
        expect(token_validator.token_hash[:image]).to eq("https://lh4.googleusercontent.com/-2KGQauB9ezg/AAAAAAAAAAI/AAAAAAAAAAs/92F79-o1zFA/s96-c/photo.jpg")
      end
    end
  end

  context "with an invalid token" do
    describe ".perform" do
      describe "with expired token" do
        it "returns false" do
          stub_expired_token_request
          response = GoogleTokenValidator.perform(google_token)
          expect(response).to be(false)
        end
      end

      describe "with non-google token" do
        it "returns false" do
          stub_non_google_token_request
          response = GoogleTokenValidator.perform(google_token)
          expect(response).to be(false)
        end
      end

      describe "with token from a different client id" do
        it "returns false" do
          stub_invalid_client_id_request
          response = GoogleTokenValidator.perform(google_token)
          expect(response).to be(false)
        end
      end
    end
  end

  def google_token
    { google_token: SecureRandom.hex(20) }.to_json
  end
end
