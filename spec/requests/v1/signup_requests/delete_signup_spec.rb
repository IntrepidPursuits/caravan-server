require "rails_helper"

describe "Signup Request" do
  describe "DELETE /signups/:id" do
    context "authenticated user" do
      let(:current_user) { create(:user) }

      context "signup is for the current user" do
        it "deletes the signup" do
          signup = create(:signup, user: current_user)

          delete(
            signup_url(signup),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :no_content
          expect { Signup.find(signup.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "signup is for a different user" do
        it "returns 403 Forbidden" do
          signup = create(:signup)

          delete(
            signup_url(signup),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :forbidden
          expect(parsed_body["errors"])
            .to include "User is not authorized to perform this action"
        end
      end

      context "not a real signup id" do
        it "returns JSON with error" do
          delete(
            signup_url("fake_id"),
            headers: authorization_headers(current_user)
          )

          expect(response).to have_http_status :not_found
          expect(parsed_body["errors"]).to include "Couldn't find Signup with 'id'=fake_id"
        end
      end
    end

    context "unauthenticated user" do
      context "no authorization header" do
        it "returns 401 Unauthorized" do
          signup = create(:signup)

          delete(
            signup_url(signup),
            headers: accept_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end

      context "invalid access token" do
        it "returns 401 Unauthorized" do
          signup = create(:signup)

          delete(
            signup_url(signup),
            headers: invalid_authorization_headers
          )

          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end
end
