require "rails_helper"

describe "Stop Request" do
  describe "POST /trips/:trip_id/stops" do
    context "authenticated user" do
      context "user is signed up for the trip" do
        context "with valid info" do
          it "returns valid JSON for the stop" do

          end
        end

        context "with invalid info" do
          context "nil values" do
            it "raises 400 Bad Request" do

            end
          end

          context "missing values" do
            it "raises 400 Bad Request" do

            end
          end

          context "invalid values" do
            it "raises 422 Unprocessable Entity" do

            end
          end
        end

        context "user is not signed up for the trip" do
          it "returns 403 Forbidden" do

          end
        end

        context "invalid trip_id" do
          it "returns 404 Not Found" do

          end
        end
      end
    end

    context "unauthenticated user" do
      context "no authorization header" do
        it "returns 401 Unauthorized" do

        end
      end

      context "with invalid token" do
        it "returns 401 Unauthorized" do

        end
      end
    end
  end
end
