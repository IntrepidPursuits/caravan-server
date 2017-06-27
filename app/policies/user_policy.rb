class UserPolicy < ApplicationPolicy
  attr_reader :current_user, :other_user

  def initialize(current_user, other_user)
    @current_user = current_user
    @other_user = other_user
  end

  def current_user?
    current_user == other_user
  end
end
