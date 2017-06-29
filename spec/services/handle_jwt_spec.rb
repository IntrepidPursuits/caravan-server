require "rails_helper"

RSpec.describe HandleJwt do
  describe ".encode" do
    let(:user) { create(:user) }

    context "with no expiration datetime specified" do
      it "creates an access token for in-app authentication" do
        access_token = HandleJwt.encode(user: user)
        expect(access_token).to be_a String
      end
    end

    context "with an expiration datetime specified" do
      it "creates an access token for in-app authentication" do
        access_token = HandleJwt.encode(user: user, expires_at: 1.hour.from_now)
        expect(access_token).to be_a String
      end
    end
  end

  describe ".decode" do
    let(:user) { create(:user) }

    context "with no expiration datetime specified" do
      let!(:access_token) { HandleJwt.encode(user: user) }
      context "with a valid access token" do
        it "returns the decoded payload for in-app authentication" do
          Timecop.freeze
          payload = HandleJwt.decode(access_token: access_token)
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
            HandleJwt.decode(access_token: access_token)
          end.to raise_error JWT::ExpiredSignature
        end
      end
    end

    context "with an expiration datetime specified" do
      let!(:access_token) do
        HandleJwt.encode(user: user, expires_at: 1.hour.from_now)
      end
      context "with a valid access token" do
        it "returns the decoded payload" do
          Timecop.freeze
          payload = HandleJwt.decode(access_token: access_token)
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
            HandleJwt.decode(access_token: access_token)
          end.to raise_error JWT::ExpiredSignature
        end
      end
    end
  end
end
