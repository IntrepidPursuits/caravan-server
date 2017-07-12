require "rails_helper"

RSpec.describe "TwitterAuthenticator" do
  describe ".perform" do
    context "with valid credentials" do
      before(:each) do
        allow_any_instance_of(TwitterTokenValidator).to receive(:tokens_valid?).and_return(true)
        allow_any_instance_of(TwitterAuthenticator).to receive(:token_hash).and_return(token_hash)
      end

      context "for an existing User and TwitterIdentity" do
        it "updates the User and TwitterIdentity records" do
          create(:twitter_identity, twitter_id: "883389619680804864")
          starting_user_count = User.count
          starting_twitter_id_count = TwitterIdentity.count

          user = TwitterAuthenticator.perform(twitter_token, twitter_token_secret)

          expect(user).to be_a User
          expect(user.twitter_identity).to be_a TwitterIdentity
          expect(User.count).to eq(starting_user_count)
          expect(TwitterIdentity.count).to eq(starting_twitter_id_count)
          expect_valid_twitter_fixture_attributes(user)
        end
      end

      context "for a new User" do
        it "creates new User and TwitterIdentity records" do
          starting_user_count = User.count
          starting_twitter_id_count = TwitterIdentity.count

          user = TwitterAuthenticator.perform(twitter_token, twitter_token_secret)

          expect(user).to be_a User
          expect(user.twitter_identity).to be_a TwitterIdentity
          expect(User.count).to eq(starting_user_count + 1)
          expect(TwitterIdentity.count).to eq(starting_twitter_id_count + 1)
          expect_valid_twitter_fixture_attributes(user)
        end
      end
    end

    context "with invalid tokens" do
      it "should raise UnauthorizedTwitterAccess" do
        expect_any_instance_of(TwitterTokenValidator)
          .to receive(:tokens_valid?).and_return(false)
        expect { TwitterAuthenticator.perform("123", "456") }
          .to raise_error(UnauthorizedTwitterAccess, "Invalid token: Check that you have the correct token and token secret.")
      end
    end

    context "with missing parameter" do
      it "should raise ArgumentError" do
        expect { TwitterAuthenticator.perform("123") }
          .to raise_error(ArgumentError, "wrong number of arguments (given 1, expected 2)")
      end
    end
  end

  def token_hash
    {
      image: twitter_profile_info["profile_image_url"],
      name: twitter_profile_info["name"],
      screen_name: twitter_profile_info["screen_name"],
      twitter_id: twitter_profile_info["id_str"]
    }
  end

  def twitter_profile_info
    JSON.parse(load_fixture("twitter_info_response.json"))
  end
end
