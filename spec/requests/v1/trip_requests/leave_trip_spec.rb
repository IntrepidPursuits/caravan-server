require "rails_helper"

describe "Trip Request" do
  describe "DELETE /trips/:trip_id/leave" do
    context "authenticated user" do
      let(:current_user) { create(:user) }

      context "user is signed up for the trip" do
        it "deletes the signup and returns No Content" do
          signup = create(:signup, user: current_user)

          delete(
            trip_leave_url(signup.trip),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :no_content
          expect { Signup.find(signup.id) }
            .to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "user is not signed up for the trip" do
        it "returns JSON with error" do
          trip = create(:trip)

          delete(
            trip_leave_url(trip),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :bad_request
          expect(parsed_body["errors"])
            .to include "You are not signed up for this trip"
        end
      end

      context "not a real trip id" do
        it "returns JSON with error" do
          delete(
            trip_leave_url("fake_trip"),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :not_found
          expect(parsed_body["errors"])
            .to include "Couldn't find Trip with 'id'=fake_trip"
        end
      end
    end

    context "unauthenticated user" do
      context "no authorization header" do
        it "returns 401 Unauthorized" do
          signup = create(:signup)

          delete(
            trip_leave_url(signup.trip),
            headers: accept_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end

      context "invalid access token" do
        it "returns 401 Unauthorized" do
          signup = create(:signup)

          delete(
            trip_leave_url(signup.trip),
            headers: invalid_authorization_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end
end
