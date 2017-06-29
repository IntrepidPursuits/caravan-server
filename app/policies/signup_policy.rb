class SignupPolicy < ApplicationPolicy
  attr_reader :user, :signup

  def initialize(user, signup)
    @user = user
    @signup = signup
  end

  def update?
    signup.user == user
  end

  def destroy?
    signup.user == user
  end
end
