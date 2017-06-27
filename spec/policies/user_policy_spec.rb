require "rails_helper"

describe UserPolicy do
  let(:current_user) { create(:user) }

  permissions :current_user? do
    it "grants access if the user matches the current user" do
      expect(UserPolicy).to permit(current_user, current_user)
    end

    it "denies access if the user is not the current user" do
      other_user = create(:user)
      expect(UserPolicy).not_to permit(current_user, other_user)
    end
  end
end
