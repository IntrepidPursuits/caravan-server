require "rails_helper"

RSpec.describe DecodeJwt do
  describe ".perform" do
    let(:user) { create(:user) }

    context "with no expiration datetime specified" do
      let!(:access_token) { EncodeJwt.perform(user: user) }
      context "with a valid access token" do
        it "returns the decoded payload for in-app authentication" do
          Timecop.freeze
          payload = DecodeJwt.perform(access_token)
          expect(payload).to eq({
            "sub" => user.id,
            "exp" => 30.days.from_now.to_i
          })
          Timecop.return
        end
      end

      context "with an expired access token" do
        it "raises an error" do
          Timecop.travel(30.days.from_now)
          expect do
            DecodeJwt.perform(access_token)
          end.to raise_error JWT::ExpiredSignature
        end
      end
    end

    context "with an expiration datetime specified" do
      let!(:access_token) do
        EncodeJwt.perform(user: user, expires_at: expires_at)
      end
      let(:expires_at) { 1.hour.from_now }
      context "with a valid access token" do
        it "returns the decoded payload" do
          Timecop.freeze
          payload = DecodeJwt.perform(access_token)
          expect(payload).to eq({
            "sub" => user.id,
            "exp" => 1.hour.from_now.to_i
          })
          Timecop.return
        end
      end

      context "with an expired access token" do
        it "raises an error" do
          Timecop.travel(expires_at)
          expect do
            DecodeJwt.perform(access_token)
          end.to raise_error JWT::ExpiredSignature
        end
      end
    end
  end
end
