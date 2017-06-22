require "rails_helper"

RSpec.describe EncodeJwt do
  describe ".perform" do
    let(:user) { create(:user) }

    context "with no expiration datetime specified" do
      it "creates an access token for in-app authentication" do
        access_token = EncodeJwt.perform(user: user)
        expect(access_token).to be_a String
      end
    end

    context "with an expiration datetime specified" do
      it "creates an access token for in-app authentication" do
        access_token = EncodeJwt.perform(user: user,
          expiration_datetime: 1.hour.from_now)
        expect(access_token).to be_a String
      end
    end
  end
end
