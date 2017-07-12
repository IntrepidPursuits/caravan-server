module Helpers
  module AuthExpectations
    def expect_valid_twitter_fixture_attributes(user)
      expect(user.name).to eq("Marjie Lam")
      expect(user.twitter_identity.twitter_id).to eq("883389619680804864")
      expect(user.twitter_identity.screen_name).to eq("lam_marjie")
      expect(user.twitter_identity.image)
        .to eq("http://abs.twimg.com/sticky/default_profile_images/default_profile_normal.png")
      expect(user.twitter_identity.provider).to eq("twitter")
    end
  end
end
