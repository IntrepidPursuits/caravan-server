require "rails_helper"

RSpec.describe "TwitterTokenValidator" do
  context "with a valid token and token secret" do
    before(:each) do
      stub_twitter_token_request
    end

    describe ".new" do
      it "returns a TwitterTokenValidator object" do
        validator = TwitterTokenValidator.new(twitter_token, twitter_token_secret)
        expect(validator).to be_a(TwitterTokenValidator)
      end
    end

    describe ".tokens_valid?" do
      it "returns true" do
        validator = TwitterTokenValidator.new(twitter_token, twitter_token_secret)
        expect(validator.tokens_valid?).to be(true)
      end
    end

    describe ".token_hash" do
      it "sets the token_hash" do
        validator = TwitterTokenValidator.new(twitter_token, twitter_token_secret)
        expect(validator.token_hash).to be
        expect(validator.token_hash[:name]).to eq("Marjie Lam")
        expect(validator.token_hash[:image])
          .to eq("http://abs.twimg.com/sticky/default_profile_images/default_profile_normal.png")
        expect(validator.token_hash[:screen_name]).to eq("lam_marjie")
        expect(validator.token_hash[:twitter_id]).to eq("883389619680804864")
      end
    end
  end

  context "missing a token secret" do
    describe ".new" do
      it "raises ArgumentError" do
        expect { TwitterTokenValidator.new(twitter_token) }
          .to raise_error(ArgumentError, "wrong number of arguments (given 1, expected 2)")
      end
    end
  end

  context "with invalid token or token secret" do
    describe ".new" do
      it "returns a TwitterTokenValidator object" do
        stub_invalid_twitter_token_request
        validator = TwitterTokenValidator.new(twitter_token, twitter_token_secret)
        expect(validator).to be_a(TwitterTokenValidator)
      end
    end

    describe ".tokens_valid?" do
      context "invalid or expired token" do
        it "returns false" do
          stub_invalid_twitter_token_request
          validator = TwitterTokenValidator.new(twitter_token, twitter_token_secret)
          expect(validator.tokens_valid?).to be(false)
        end
      end

      context "missing user name" do
        it "returns false" do
          stub_twitter_missing_name_request
          validator = TwitterTokenValidator.new(twitter_token, twitter_token_secret)
          expect(validator.tokens_valid?).to be(false)
        end
      end

      context "missing twitter id" do
        it "returns false" do
          stub_twitter_missing_id_request
          validator = TwitterTokenValidator.new(twitter_token, twitter_token_secret)
          expect(validator.tokens_valid?).to be(false)
        end
      end

      context "missing user image" do
        it "returns true" do
          stub_twitter_missing_image_request
          validator = TwitterTokenValidator.new(twitter_token, twitter_token_secret)
          expect(validator.tokens_valid?).to be(true)
        end
      end
    end

    describe ".token_hash" do
      context "invalid or expired token" do
        it "returns nils" do
          stub_invalid_twitter_token_request
          validator = TwitterTokenValidator.new(twitter_token, twitter_token_secret)
          expect(validator.token_hash).to be
          expect(validator.token_hash[:name]).to be(nil)
          expect(validator.token_hash[:image]).to be(nil)
          expect(validator.token_hash[:screen_name]).to be(nil)
          expect(validator.token_hash[:twitter_id]).to be(nil)
        end
      end
    end
  end
end
