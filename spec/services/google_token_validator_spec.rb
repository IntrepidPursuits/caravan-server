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
        expect(token_validator.token_hash[:google_uid]).to eq("383579238759")
        expect(token_validator.token_hash[:email]).to eq("rkonikoff@intrepid.io")
        expect(token_validator.token_hash[:name]).to eq("Riki Konikoff")
        expect(token_validator.token_hash[:image]).to eq("https://somepicture.jpg")
      end
    end
  end

  context "with an invalid token" do
    describe ".perform" do
      context "with expired token" do
        it "returns false" do
          stub_expired_token_request
          response = GoogleTokenValidator.perform(google_token)
          expect(response).to be(false)
        end
      end

      context "with non-google token" do
        it "returns false" do
          stub_non_google_token_request
          response = GoogleTokenValidator.perform(google_token)
          expect(response).to be(false)
        end
      end

      context "with token from a different client id" do
        it "returns false" do
          stub_invalid_client_id_request
          response = GoogleTokenValidator.perform(google_token)
          expect(response).to be(false)
        end
      end

      context "with a token missing email" do
        it "returns false" do
          stub_missing_email_request
          response = GoogleTokenValidator.perform(google_token)
          expect(response).to be(false)
        end
      end

      context "with a token missing uid" do
        it "returns false" do
          stub_missing_uid_request
          response = GoogleTokenValidator.perform(google_token)
          expect(response).to be(false)
        end
      end

      context "with a token missing name" do
        it "returns false" do
          stub_missing_name_request
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
